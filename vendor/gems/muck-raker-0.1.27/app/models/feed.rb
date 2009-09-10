# == Schema Information
#
# Table name: feeds
#
#  id                         :integer(4)      not null, primary key
#  uri                        :string(2083)
#  display_uri                :string(2083)
#  title                      :string(1000)
#  short_title                :string(100)
#  description                :text
#  tag_filter                 :string(1000)
#  top_tags                   :text
#  priority                   :integer(4)      default(10)
#  status                     :integer(4)      default(1)
#  last_requested_at          :datetime        default(Wed Jan 01 00:00:00 UTC 1969)
#  last_harvested_at          :datetime        default(Wed Jan 01 00:00:00 UTC 1969)
#  harvest_interval           :integer(4)      default(86400)
#  failed_requests            :integer(4)      default(0)
#  error_message              :text
#  service_id                 :integer(4)      default(0)
#  login                      :string(255)
#  password                   :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  entries_changed_at         :datetime
#  harvested_from_display_uri :string(2083)
#  harvested_from_title       :string(1000)
#  harvested_from_short_title :string(100)
#  entries_count              :integer(4)
#  default_language_id        :integer(4)      default(0)
#  default_grain_size         :string(255)     default("unknown")
#  contributor_id             :integer(4)
#  etag                       :string(255)
#

class Feed < ActiveRecord::Base

  require 'httparty'

  include HTTParty
  format :xml

  validates_presence_of :uri

  has_many :feed_parents
  has_many :identity_feeds
  has_many :entries, :dependent => :destroy
  belongs_to :contributor, :class_name => 'User', :foreign_key => 'contributor_id'
  belongs_to :default_language, :class_name => 'Language', :foreign_key => 'default_language_id'
  belongs_to :service
  
  named_scope :banned, :conditions => "status < 0"
  named_scope :valid, :conditions => "status >= 0"
  named_scope :by_title, :order => "title ASC"
  named_scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago] } }
  named_scope :by_newest, :order => "created_at DESC"

  attr_protected :status, :last_requested_at, :last_harvested_at, :harvest_interval, :failed_requests,
                 :created_at, :updated_at, :entries_changed_at, :entries_count, :contributor_id
  
  # named_scope :ready_to_harvest, lambda { |*args| { :conditions => [ "feeds.last_harvested_at < ?", args.first || 1.day.ago.end_of_day ] } }

  def banned?
    self.status < 0
  end
  
  def after_create
    if GlobalConfig.inform_admin_of_global_feed && self.feed_parents.empty?
      RakerMailer.deliver_notification_feed_added(self) # Global feed.  Email the admin to let them know a feed has been added
    end
  end

  # harvest_interval is stored in seconds
  # default is 86400 which is one day
  def harvest_interval_hours
    self.harvest_interval/3600
  end

  # Converts hours into seconds for harvest_interval
  def harvest_interval_hours=(interval)
    self.harvest_interval = interval * 3600
  end

  def harvest
    # check to see if the feed has changed
    feed = Feedzirra::Feed.fetch_and_parse(self.uri)
    feed.entries
    # updated_feed = Feedzirra::Feed.update(self)
    # if updated_feed.updated?
    #   updated_feed.new_entries # get new entries
    #   updated_feed.sanitize_entries! # clean up
    # end
  end

  # provided to make feed quack like a feedzirra feed
  def url
    display_uri
  end

  # provided to make feed quack like a feedzirra feed
  def feed_url
    uri
  end

  # provided to make feed quack like a feedzirra feed
  def last_modified
    entries_changed_at
  end
  
  # This will delete a feed if there are no references to it
  def delete_if_unused(user)
    if user.id == contributor_id
      feed = FeedParent.find_by_feed_id(self.id)
      return false if feed # feed is still being used
      feed = IdentityFeed.find_by_feed_id(self.id)
      return false if feed # feed is still being used
      self.destroy
    else
      false
    end
  end
  
  # Gathers all available feed uris from the given uri and parses them into
  # feed objects
  def self.gather_information(uri)
    feeds = []
    @available_feeds = discover_feeds(uri)
    @available_feeds.each do |feed|
      feeds << from_feedzirra(Feedzirra::Feed.fetch_and_parse(feed.url))
    end
    feeds
  end

  # Turns a feed from feedzirra into a muck feed
  def self.from_feedzirra(feed)
    Feed.new(:short_title => feed.title,
             :title => feed.title,
             :display_uri => feed.url,
             :uri => feed.feed_url)
  end

  # Looks for feeds from a given url
  def self.discover_feeds(uri)
    Feedbag.find(uri)
  end

  # creates a feed for a service with a username and optional password
  def self.create_service_feeds(service, uri, username, password, contributor_id)
    uris = service.generate_uris(username, password, uri)
    uris.collect{ |u| Feed.find_or_create(u.url, u.title, username, password, service.id, contributor_id) } if uris
  end
  
  # Finds or creates a feed based on the url.  Any give feed uri should only exist once in the system
  def self.find_or_create(uri, title, username, password, service_id, contributor_id)
    Feed.find_by_uri(uri) ||
      Feed.new(:uri => uri,
               :harvest_interval => '01:00:00',
               :last_harvested_at => Time.at(0),
               :title => title,
               :login => username,
               :password => password,
               :service_id => service_id,
               :contributor_id => contributor_id)
  end
  
end
