# == Schema Information
#
# Table name: services
#
#  id                  :integer(4)      not null, primary key
#  uri                 :string(2083)    default("")
#  name                :string(1000)    default("")
#  api_uri             :string(2083)    default("")
#  uri_template        :string(2083)    default("")
#  icon                :string(2083)    default("rss.gif")
#  sort                :integer(4)
#  requires_password   :boolean(1)
#  is_identity         :boolean(1)
#  service_category_id :integer(4)
#  active              :boolean(1)      default(TRUE)
#

require File.dirname(__FILE__) + '/../test_helper'

class ServiceTest < ActiveSupport::TestCase

  context "service instance" do
    should_belong_to :service_category
    should_have_named_scope :sorted
    should_have_named_scope :identity_services
    should_have_named_scope :tag_services
  end
  
  context "identity services" do
    should "generate uri using blog url" do
      service = Factory(:service)
      uris = service.generate_uris('', '', TEST_URI)
      assert uris.map(&:url).include?(TEST_RSS_URI)
    end
    should "generate uri using username" do
      service = Factory(:service, :uri_template => TEST_USERNAME_TEMPLATE)
      uris = service.generate_uris('jbasdf', '', '')
      assert uris.map(&:url).include?(TEST_USERNAME_TEMPLATE.sub('{username}', 'jbasdf'))
    end
    should "get twitter uri from username" do
      service = Factory(:service, :uri_template => "http://www.twitter.com/{username}")
      uris = service.generate_uris('jbasdf', '', '')
      assert uris.map(&:url).include?("http://twitter.com/statuses/user_timeline/7219042.rss")
    end
  end
  
  context "tag services" do
    setup do
      @template = "http://example.com/{tag}"
      Factory(:service, :uri_template => @template, :use_for => 'tags')
    end
    should "generate feeds for tag" do
      tag = 'rails'
      uris = Service.generate_tag_uris(tag)
      assert uris.include?(@template.sub('{tag}', tag))
    end
  end
  
  context "amazon wish list" do
    setup do
      @email = 'justinball@gmail.com'
    end
    should "get wishlist" do
      Service.get_amazon_feeds(@email)
    end
  end
  
end
