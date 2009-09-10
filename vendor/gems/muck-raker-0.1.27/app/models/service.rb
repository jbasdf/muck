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

class Service < ActiveRecord::Base
  
  belongs_to :service_category
  named_scope :sorted, :order => "sort ASC"
  named_scope :identity_services, :conditions => ['use_for = ?', 'identity']
  named_scope :tag_services, :conditions => ['use_for = ?', 'tags']
  
  def generate_uris(username = '', password = '', uri = '')
    if self.name == 'Facebook'
      # Facebook can't just use feeds like everyone else.
      params = {}
      pairs = uri.split('?')[1].split('&')
      pairs.each do |pair|
        p = pair.split('=')
        params[p[0].to_sym] = p[1]
      end
      uris = []
      uris << OpenStruct.new(:url => "http://www.facebook.com/feeds/notifications.php?id=#{params[:id]}&viewer=#{params[:id]}&key=#{params[:key]}&format=rss20", :title => I18n.t('muck.raker.facebook_notifications'))
      uris << OpenStruct.new(:url => "http://www.facebook.com/feeds/share_posts.php?id=#{params[:id]}&viewer=#{params[:id]}&key=#{params[:key]}&format=rss20", :title => I18n.t('muck.raker.facebook_shares'))
      uris << OpenStruct.new(:url => "http://www.facebook.com/feeds/notes.php?id=#{params[:id]}&viewer=#{params[:id]}&key=#{params[:key]}&format=rss20", :title => I18n.t('muck.raker.facebook_notes'))
      uris
    elsif self.name == 'Amazon'
      # Have to build and sign Amazon wishlist rss feeds
      am = AmazonRequest.new(GlobalConfig.amazon_access_key_id, GlobalConfig.amazon_secret_access_key, GlobalConfig.amazon_associate_tag)
      am.get_amazon_feeds(username) # username needs to be the user's Amazon email
    elsif !self.uri_template.blank? && !username.blank?
      uri = self.uri_template.sub("{username}", username)
      Feed.discover_feeds(uri)
    elsif !uri.blank?
      Feed.discover_feeds(uri)
    end
  end

  # Generate a uri for the current service
  def generate_tag_uri(tag)
    self.uri_template.sub("{tag}", tag)
  end
  
  # Generates uris for 'tag' using all services where 'use_for' is 'tags'
  def self.generate_tag_uris(tag)
    Service.tag_services.collect { |service| service.generate_tag_uri(tag) }
  end
  
end
