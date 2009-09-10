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

require File.dirname(__FILE__) + '/../test_helper'

# Used to test muck_content_permission
class FeedTest < ActiveSupport::TestCase

  context "A feed instance" do
    setup do
      @feed = Factory(:feed)
    end
    should_have_many :feed_parents
    should_have_many :entries
    should_belong_to :contributor
    should_belong_to :default_language
    should_belong_to :service
    
    should_validate_presence_of :uri
    
    should_have_named_scope :by_newest
    should_have_named_scope :banned
    should_have_named_scope :valid
    should_have_named_scope :by_title
    should_have_named_scope :recent
    
    should "set 24 hours as default interval" do
      assert_equal @feed.harvest_interval_hours, 24
    end
    
    should "set harvest interval by hours" do
      @feed.harvest_interval_hours = 10
      assert_equal @feed.harvest_interval, 10 * 3600
    end
    
  end
  
  context "banned/unbanned" do
    setup do
      @feed = Factory(:feed)
    end
    should "be banned" do
      @feed.status = -1
      assert @feed.banned?
    end
    should "not be banned" do
      @feed.status = 0
      assert !@feed.banned?
    end
  end
  
  context "Get feed information" do
    should "Get feed information" do
      Feed.gather_information(TEST_URI)
    end
    should "Discover feeds from url" do
      Feed.discover_feeds(TEST_URI)
    end
  end
  
  context "Harvest feed" do
    setup do
      @feed = Factory(:feed, :uri => TEST_RSS_URI, :display_uri => TEST_URI)
    end
    should "get new entries" do
      entries = @feed.harvest
      assert entries.length > 0
    end
  end
  
  context "Delete feed if unused" do
    setup do
      @user = Factory(:user)
      @identity_user = Factory(:user)
      @delete_feed = Factory(:feed, :contributor => @user)
      @dont_delete_feed = Factory(:feed, :contributor => @user)
      @identity_user.own_feeds << @dont_delete_feed
    end
    should "delete feed" do
      assert @delete_feed.delete_if_unused(@user)
    end
    should "not delete feed" do
      assert !@dont_delete_feed.delete_if_unused(@user)
    end
  end
  
  context "Create feed from service" do
    setup do
      @login = 'jbasdf'
      @password = ''
      @uri_template = TEST_USERNAME_TEMPLATE
      @service = Factory(:service, :uri_template => @uri_template)
      @user = Factory(:user)
    end
    should "create feed from service" do
      feeds = Feed.create_service_feeds(@service, '', @login, @password, @user.id)
      feed = feeds[0]
      assert_equal @uri_template.sub("{username}", @login), feed.uri
      assert_equal @login, feed.login
      assert_equal @password, feed.password
      assert_equal @service.id, feed.service_id
    end
    should "create feed from service even with nil template" do
      feeds = Feed.create_service_feeds(@service, '', @login, @password, @user.id)
      feed = feeds[0]
      assert_equal @uri_template.sub("{username}", @login), feed.uri
      assert_equal @login, feed.login
      assert_equal @password, feed.password
      assert_equal @service.id, feed.service_id
    end
  end
  
end
