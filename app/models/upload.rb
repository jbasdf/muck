class Upload < ActiveRecord::Base
  
  acts_as_uploader :has_attached_file => {
    :url     => "/uploads/:class/:id/:style_:basename.:extension",
    :path    => ":rails_root/public/uploads/:class/:id/:style_:basename.:extension",
    :styles  => { :icon => "30x30!", :thumb => "100>", :small => "150>", :medium => "300>", :large => "660>"},
    :default_url => "/images/profile_default.jpg" }
  
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'
  has_many :shared_uploads, :dependent => :destroy
  
  acts_as_taggable
  
  named_scope :tagged_with, lambda {|tag_name| {:conditions => ["is_public = true AND tags.name = ?", tag_name], :include => :tags} }
  
  # def after_create
    #  do add_activity
  # end
  
  def share_with_friend(sharer, friend_id)
    friend = User.find(friend_id)
    friend.shared_uploads.find_or_create_by_upload_id_and_shared_by_id(self.id, sharer.id)
  end

  def share_with_group(sharer, group_id)
    group = Group.find(group_id)
    if group.is_member?(sharer)
      shared_upload = group.shared_uploads.find_or_create_by_upload_id_and_shared_by_id(self.id, sharer.id)
    end
    # TODO decide if we want to feed this into a feed somewhere
    shared_upload
  end

  def share_with_friends(user, friend_ids)
    friend_ids.each do |friend_id, checked|
      self.share_with_friend(user, friend_id) if (checked == "1")
    end    
  end

  def share_with_groups(user, group_ids)
    group_ids.each do |group_id, checked|
      self.share_with_group(user, group_id) if (checked == "1")
    end    
  end
  
end