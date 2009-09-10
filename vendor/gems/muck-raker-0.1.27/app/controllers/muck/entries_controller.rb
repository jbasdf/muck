class Muck::EntriesController < ApplicationController
  
  unloadable
  
  def initialize
    @no_index = true
  end
  
  def index
    @grain_size = params[:grain_size] || 'all'
    @tag_cloud = TagCloud.language_tags(Language.locale_id, @grain_size) unless fragment_exist?({:controller => 'entries', :action => 'index', :language => Language.locale_id})
    respond_to do |format|
      format.html { render :template => 'entries/index' }
    end
  end
  
  def browse_by_tags
    @tag_filter = params[:tags]
    @grain_size = params[:grain_size] || 'all'
    if !fragment_exist?({:controller => 'entries', :action => 'index', :language => Language.locale_id, :filter => @tag_filter, :grain_size => @grain_size})
      @search = @tag_filter.split('/').join(' AND ') if !@tag_filter.empty? 
      @tag_cloud = TagCloud.language_tags(Language.locale_id, @grain_size, @tag_filter)
      _search(:and)
    end
    respond_to do |format|
      format.html { render :template => 'entries/browse_by_tags' }
    end
  end
  
  def search
    @search = params[:q]
    @grain_size = params[:grain_size] || 'all'
    _search
    respond_to do |format|
      format.html { render :template => 'entries/search' }
    end
  end
  
  def show
    @entry = Entry.find(params[:id], :include => :feed)
    if @entry.nil?
      render_text "Unable to find the specified document"
      return
    end
    @entry_title = @entry.title + ' (' + @entry.feed.short_title + ')'
    @page_title = @entry_title + ' - ' + I18n.t('muck.raker.related_resources_title')
#    I18n.locale = @entry.language[0..1]
    @limit = params[:limit] ? params[:limit].to_i : 20
    @limit = 40 if @limit > 40

    respond_to do |format|
      format.html do
        @recommendations = @entry.recommendations(@limit, 'relevance', params[:details] == 'true')
        if params[:details] == 'true'
          render :template => "entries/details"
        else
          render :template => "entries/show"
        end
      end
      format.xml  { render :xml => @entry }
    end
  end
  
  def track_clicks
    user_agent = request.env['HTTP_USER_AGENT']
    redirect_to Entry.track_click(session, params[:id], request.env['HTTP_REFERER'], params[:target], request.env['HTTP_X_FORWARDED_FOR'], user_agent) if !/Googlebot/.match(user_agent) 
  end
  
  def collections
    @feeds = Feed.find(:all, :order => "harvested_from_title, title")
    @languages = Language.find(:all, :order => "name")
    render :template => "documents/collections", :layout => "default"
  end

  protected

  def _search operator = :or
    @page = (params[:page] || 0).to_i
    @per_page = (params[:per_page] || 10).to_i
    @offset = @page*@per_page
    if !@search.nil?
      @term_list = URI.escape(@search) 
      results = Entry.search(@search, @grain_size, I18n.locale.to_s, @per_page, @offset, operator)
      @hit_count = results.total
      @results = results.results
      @paginated_results = @results.paginate(:page => @page+1, :per_page => @per_page, :total_entries => @hit_count)
      log_query(current_user.nil? ? request.remote_addr : current_user.id, Language.locale_id, @tag_filter.nil? ? 'search' : 'browse', @search, @grain_size, @hit_count)
    end
  end
  
  def query_logger
    @@query_logger ||= Logger.new("#{RAILS_ROOT}/log/queries_#{Date.today}.log")
  end
  
  def log_query(user_id, locale, search_type, query, grain_size, hits)
    query_logger.info "#{Time.new.to_i},#{user_id},#{locale},#{search_type},\"#{query.gsub(/"/, '\\\\"')}\",#{grain_size},#{hits}"
  end
end
