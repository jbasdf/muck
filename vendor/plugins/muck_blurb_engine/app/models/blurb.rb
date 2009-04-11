class Blurb < ActiveRecord::Base
  
  belongs_to :source, :polymorphic => true
  validates_presence_of :source
  
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at DESC'  
  has_many :activities, :as => :item, :order => 'created_at desc', :dependent => :destroy    
  
  named_scope :recent, :order => 'created_at DESC'
  
  def after_create
    feed_item = FeedItem.create(:item => self, :creator_id => self.user_id)
    (self.user.feed_to).each{ |u| u.feed_items << feed_item }
  end
  
  def can_edit?(user)
    user.id == self.user_id || user.is_admin?
  end
  
end
