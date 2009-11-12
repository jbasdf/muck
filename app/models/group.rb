class Group < ActiveRecord::Base
  
  has_friendly_id :login
  #acts_as_muck_group
  has_activities
  has_muck_feeds
  acts_as_muck_feed_owner
  acts_as_tagger
  has_muck_blog
  
  has_many :uploads, :as => :uploadable, :order => 'created_at desc', :dependent => :destroy 
  
  after_create {|group| group.memberships.create(:role => :manager, :user_id => group.creator_id)}
  after_create :create_forum
  after_create :create_feed_item
  after_update {|group| group.create_feed_item 'updated_group'}
  
  def after_create
    add_activity(self, self, self, 'welcome', '', '')
    content = I18n.t('muck.activities.joined_status', :name => self.full_name, :application_name => GlobalConfig.application_name)
    add_activity(self, self, self, 'status_update', '', content)
  end
  
  def can_upload?(check_user)
    true
  end
  
  def can_view?(check_object)
    if check_object.is_a?(User)
      self == check_object || check_object.admin?
    else
      false
    end
  end
  
  # Determines which users can add content directly to the site via muck-contents.
  def can_add_root_content?
    admin?
  end
  
end
