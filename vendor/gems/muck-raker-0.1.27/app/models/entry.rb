# == Schema Information
#
# Table name: entries
#
#  id                      :integer(4)      not null, primary key
#  feed_id                 :integer(4)      not null
#  permalink               :string(2083)    default(""), not null
#  author                  :string(2083)
#  title                   :text            default(""), not null
#  description             :text
#  content                 :text
#  unique_content          :boolean(1)
#  published_at            :datetime        not null
#  entry_updated_at        :datetime
#  harvested_at            :datetime
#  oai_identifier          :string(2083)
#  language_id             :integer(4)
#  direct_link             :string(2083)
#  indexed_at              :datetime        default(Fri Jan 01 01:01:01 UTC 1971), not null
#  relevance_calculated_at :datetime        default(Fri Jan 01 01:01:01 UTC 1971), not null
#  popular                 :text
#  relevant                :text
#  other                   :text
#  grain_size              :string(255)     default("unknown")
#
# Indexes
#
#  index_entries_on_direct_link              (direct_link)
#  index_entries_on_feed_id                  (feed_id)
#  index_entries_on_indexed_at               (indexed_at)
#  index_entries_on_language_id              (language_id)
#  index_entries_on_oai_identifier           (oai_identifier)
#  index_entries_on_permalink                (permalink)
#  index_entries_on_published_at             (published_at)
#  index_entries_on_relevance_calculated_at  (relevance_calculated_at)
#  index_entries_on_grain_size               (grain_size)
#

class Entry < ActiveRecord::Base
  
  unloadable
  
  belongs_to :feed
  belongs_to :language
  has_many :activities, :as => :attachable, :dependent => :destroy
  has_many :attentions, :dependent => :destroy
  acts_as_commentable
  acts_as_taggable
  
  @@default_time_on_page = 60.0
  
  acts_as_solr({:if => false, :fields => [{:feed_id => :integer}, {:grain_size => :string}]}, {:type_field => :type_s})

  def resource_uri 
    self.direct_link.nil? ? self.permalink : self.direct_link
  end
  
  def self.top_tags(tags = nil)
    
  end
  
  def self.search(search_terms, grain_size = nil, language = "en", limit = 10, offset = 0, operator = :or)
    query = (!grain_size.nil? && grain_size != 'all') ? (search_terms + ") AND (grain_size:#{grain_size}") : search_terms
    return find_by_solr(query, :limit => limit, :offset => offset, :scores => true, :select => "entries.id, entries.title, entries.permalink, entries.direct_link, entries.published_at, entries.description, entries.feed_id, feeds.short_title AS collection", :joins => "INNER JOIN feeds ON feeds.id = entries.feed_id", :core => language, :operator => operator)
  end

  def self.recommender_entry(uri)
    uri = normalized_uri(uri)
    Entry.find(:first, :conditions => ['permalink = ? OR direct_link = ?', uri, uri], :order => 'direct_link IS NULL DESC') || Entry.new(:permalink => uri)
  end
  
  def recommendations(limit = 20, order = "relevance", details = false, omit_feeds = nil)
    sql = "SELECT recommendations.id, dest_entry_id, entries.permalink, entries.title, entries.description, entries.direct_link, feeds.short_title AS collection "
    sql << ", relevance_calculated_at, relevance, clicks, avg_time_at_dest AS avg_time_on_target, author, published_at " if details == true
    sql << "FROM recommendations "
    sql << "INNER JOIN entries ON recommendations.dest_entry_id = entries.id "
    sql << "INNER JOIN feeds ON entries.feed_id = feeds.id "
    sql << "WHERE recommendations.entry_id = ? "
    sql << ("AND entries.feed_id NOT IN (" + omit_feeds.gsub(/[^0-9,]/,'') + ") ") if omit_feeds != nil
    sql << "ORDER BY " + order + " DESC "
    sql << "LIMIT " + limit.to_s
    Entry.find_by_sql([sql,self.id])
  end

  def recommendation_entries(limit = 20, order = "relevance", details = false, omit_feeds = nil)
    sql = "SELECT recommendations.dest_entry_id AS id, entries.permalink, entries.title, entries.description, entries.direct_link, feeds.short_title AS collection "
    sql << ", relevance_calculated_at, relevance, clicks, avg_time_at_dest AS avg_time_on_target, author, published_at " if details == true
    sql << "FROM recommendations "
    sql << "INNER JOIN entries ON recommendations.dest_entry_id = entries.id "
    sql << "INNER JOIN feeds ON entries.feed_id = feeds.id "
    sql << "WHERE recommendations.entry_id = ? "
    sql << ("AND entries.feed_id NOT IN (" + omit_feeds.gsub(/[^0-9,]/,'') + ") ") if omit_feeds != nil
    sql << "ORDER BY " + order + " DESC "
    sql << "LIMIT " + limit.to_s
    Entry.find_by_sql([sql,self.id])
  end

  def self.track_time_on_page(session, uri)
    recommendation_id = session[:last_clicked_recommendation]
    if !recommendation_id.nil?
      time_on_page = (Time.now - session[:last_clicked_recommendation_time].to_f).to_i
      
      # if they spend longer than two minutes on a page, we don't infer anything
      if time_on_page > 5 and time_on_page < 120
        if normalized_uri(uri) != session[:last_clicked_recommendation_uri] 
          recommendation = Recommendation.find(recommendation_id)
          entry = Entry.find(recommendation.entry_id)
          new_avg = (recommendation.avg_time_at_dest*recommendation.clicks - @@default_time_on_page + time_on_page)/recommendation.clicks
          recommendation.avg_time_at_dest = new_avg
          recommendation.save!
          entry.rank_recommendations
          session[:last_clicked_recommendation] = nil
        end
      else
        session[:last_clicked_recommendation] = nil if time_on_page > 5
      end
    end
  end
  
  def self.avg_time(clicks, old_avg, time_on_page)
    return (old_avg*(clicks-1) + time_on_page)/clicks
  end

  def self.track_click(session, recommendation_id, referrer, redirect_type = "direct_link", requester = "unknown", user_agent = "unknown")
    # look up the recommendation
    recommendation = Recommendation.find(recommendation_id)
    return "" if !recommendation
    
    # get the entries being linked from and to
    entry = Entry.find(recommendation.entry_id)
    target = Entry.find(recommendation.dest_entry_id)
    
    # get the list of recommendations that have been clicked during this session
    clicks = session[:rids] || Array.new
    
    # redirect to our frame page
    redirect = "/visits/#{recommendation.dest_entry_id}"
    
    # track the time on the last page
    track_time_on_page(session, redirect)
    
    # if this is first time the user clicked on this recommendation during this session 
    if !clicks.include?(recommendation_id)
      
      # add this recommendation to the end of the list 
      clicks << recommendation_id
      session[:rids] = clicks
      
      # update the click time
      recommendation.avg_time_at_dest = ((recommendation.avg_time_at_dest*recommendation.clicks) + @@default_time_on_page)/(recommendation.clicks + 1) 
      recommendation.clicks += 1 
      recommendation.save!
      
      # store info about this click in the session
      now = Time.now
      session[:last_clicked_recommendation] = recommendation_id
      session[:last_clicked_recommendation_time] = now
      session[:last_clicked_recommendation_uri] = redirect

      # update the recommendation cache for the entry
      entry.rank_recommendations if entry
      
      # track the click in the db
      Click.create(:recommendation_id => recommendation_id, :when => now, :referrer => referrer, :requester => requester, :user_agent => user_agent)
    end
    
    return redirect   
  end

  def relevant_recommendations(limit = 5, order = "relevance", details = false, omit_feeds = nil)
    return self.recommendations(limit, order, details, omit_feeds)
  end

  def self.truncate_words(text, length = 30, end_string = ' ...')
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
  
  def ranked_recommendations(limit = 5, order = "mixed", details = false, omit_feeds = nil)
    if self.id.nil?
      return Entry.real_time_recommendations(self.permalink, details, :core => 'en', :limit => limit) 
    else
      return relevant_recommendations(limit, "clicks DESC, relevance", details, omit_feeds) if order == "clicks" 
      return relevant_recommendations(limit, "relevance", details, omit_feeds) if (order == "relevance" || details == true)
      return relevant_recommendations_filtered(limit, details, omit_feeds) if omit_feeds != nil 
    end

    recs = []
    if self.popular != nil && !self.popular.empty?
      recs.concat(ActiveSupport::JSON.decode(self.popular).first(limit))
    end
    if recs.length < limit && self.relevant != nil && !self.relevant.empty?
      relevant_recs = randomize(ActiveSupport::JSON.decode(self.relevant))
      recs.concat(relevant_recs.first(limit - recs.length))
    end
    if recs.length < limit && self.relevant != nil && !self.other.empty?
      other_recs = randomize(ActiveSupport::JSON.decode(self.other))
      recs.concat(other_recs.first(limit - recs.length))
    end
    return recs
  end
  
  def relevant_recommendations_filtered(limit, details, omit_feeds)
    # get recommendations for the entry from the recommendations table
    recs = self.recommendations(limit, "mixed", details, omit_feeds)
    
    # for storing the various lists
    popular_recs = []
    relevant_recs = []
    other_recs = []

    # see where to cut draw the lines for popular and relevant
    click_threshold = calc_click_threshold(recs)
    relevance_threshold = calc_relevance_threshold(recs)
    
    # store the recommendations
    recs.each do |r|
      if (r["clicks"].to_i > click_threshold)
        popular_recs << r 
      elsif (r["relevance"].to_f > relevance_threshold)
        relevant_recs << r
      else 
        other_recs << r
      end
    end
    
    # order popular items strictly by clicks
    popular_recs.sort{|r1,r2| r2["avg_time_on_target"].to_i <=> r1["avg_time_on_target"].to_i}
    
    return popular_recs[0..limit] if popular_recs.size > limit 
    return (popular_recs + relevant_recs)[0..limit] if (popular_recs.size + relevant_recs.size) > limit
    return (popular_recs + relevant_recs + other_recs)[0..limit]
  end

  def json_recommendations(limit = 5, order = "mixed", details = false, omit_feeds = nil)
    ActiveSupport::JSON.encode(ranked_recommendations(limit, order, details, omit_feeds))
  end
  
  def rank_recommendations
    return
    # get recommendations for the entry from the recommendations table
    recs = self.recommendations
    
    # for storing the various lists
    popular_recs = []
    relevant_recs = []
    other_recs = []

    # see where to cut draw the lines for popular and relevant
    click_threshold = calc_click_threshold(recs)
    relevance_threshold = calc_relevance_threshold(recs)
    
    # store the recommendations
    recs.each do |r|
      if (r["clicks"].to_i > click_threshold)
        popular_recs << r 
      elsif (r["relevance"].to_f > relevance_threshold)
        relevant_recs << r
      else 
        other_recs << r
      end
    end
    
    # order popular items strictly by clicks
    popular_recs.sort{|r1,r2| r2["avg_time_on_target"].to_i <=> r1["avg_time_on_target"].to_i}
    
    # cache the JSON for the lists in the entry record
    self.popular = ActiveSupport::JSON.encode(popular_recs)
    self.relevant = ActiveSupport::JSON.encode(relevant_recs)
    self.other = ActiveSupport::JSON.encode(other_recs)
    self.save!
  end
  
  def randomize(recs)
    i = recs.length
    return recs if (i == 0)
    while (i > 0)
      i = i - 1
      j = (rand*(i+1)).floor
      ti = recs[i]
      tj =recs[j]
      recs[i] = tj
      recs[j] = ti
    end
    return recs
  end

  def calc_relevance_threshold(recs)
    sum = 0
    recs.each do |r|
      sum += r["relevance"].to_f
    end
    average = sum/recs.length
    sum = 0
    recs.each do |r|
      sum += (r["relevance"].to_f-average)**2
    end
    standard_deviation = Math.sqrt(sum/recs.length);
    return average + standard_deviation
  end
  
  def calc_click_threshold(recs)
    sum = 0
    recs.each do |r|
      sum += r["clicks"].to_f
    end
    average = sum/recs.length
    sum = 0
    recs.each do |r|
      sum += (r["clicks"].to_f-average)**2
    end
    standard_deviation = Math.sqrt(sum/recs.length);
    threshold = average + standard_deviation
    return threshold > 5 ? threshold : 5
  end
  
  protected
  
#  def self.redirect_uri(target, referrer, redirect_type)
#    if !target.direct_link.nil? and redirect_type != "metadata"
#      return target.direct_link if redirect_type == "direct_link" 
#      if !referrer.nil?
#        domain = "http://" + URI.parse(referrer).host
#        return target.direct_link if target.permalink[0..domain.length-1] != domain
#      end
#    end
#    return target.permalink
#  end

  def self.normalized_uri(uri)
    uri.sub(/index.?\.(html|aspx|shtm|htm|asp|php|cfm|jsp|shtml|jhtml)$/, '')
  end
  
  def self.real_time_recommendations(uri, details = false, options = {})
    fields = "entries.id, entries.title, entries.permalink, entries.direct_link, feeds.short_title AS collection"
    fields << ", entries.published_at, entries.description, entries.author" if details == true 
    more_like_this(uri, options.merge(:select => fields, :joins => "INNER JOIN feeds ON feeds.id = entries.feed_id"))
  end

end
