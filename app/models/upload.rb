# == Schema Information
#
# Table name: uploads
#
#  id                  :integer(4)      not null, primary key
#  creator_id          :integer(4)
#  name                :string(255)
#  caption             :string(1000)
#  description         :text
#  is_public           :boolean(1)      default(TRUE)
#  uploadable_id       :integer(4)
#  uploadable_type     :string(255)
#  width               :string(255)
#  height              :string(255)
#  local_file_name     :string(255)
#  local_content_type  :string(255)
#  local_file_size     :integer(4)
#  local_updated_at    :datetime
#  remote_file_name    :string(255)
#  remote_content_type :string(255)
#  remote_file_size    :integer(4)
#  remote_updated_at   :datetime
#  created_at          :datetime
#  updated_at          :datetime
#
# Indexes
#
#  index_uploads_on_creator_id          (creator_id)
#  index_uploads_on_uploadable_id       (uploadable_id)
#  index_uploads_on_uploadable_type     (uploadable_type)
#  index_uploads_on_local_content_type  (local_content_type)
#

class Upload < ActiveRecord::Base
  
  acts_as_uploader  :enable_s3 => false,
                    :has_attached_file => {
                      :url     => "/system/:attachment/:id_partition/:style/:basename.:extension",
                      :path    => ":rails_root/public/system/:attachment/:id_partition/:style/:basename.:extension",
                      :styles  => { :icon => "30x30!", 
                                    :thumb => "100>", 
                                    :small => "150>", 
                                    :medium => "300>", 
                                    :large => "660>" },
                      :default_url => "/images/profile_default.jpg",
                      :storage => :s3,
                      :s3_credentials => AMAZON_S3_CREDENTIALS,
                      :bucket => "assets.#{GlobalConfig.application_url}",
                      :s3_host_alias => "assets.#{GlobalConfig.application_url}",
                      :convert_options => {
                         :all => '-quality 80'
                       }
                    },
                    :s3_path => ':id_partition/:style/:basename.:extension'

  # has_many :comments, :as => :commentable, :dependent => :destroy, :order => 'created_at ASC'
  # has_many :shared_uploads, :dependent => :destroy
  
  acts_as_taggable
  
  named_scope :public, :conditions => "is_public = true"
  named_scope :tagged_with, lambda {|tag_name| {:conditions => ["tags.name = ?", tag_name], :include => :tags} }
  
  # def after_create
    #  do add_activity
  # end
  
  # def share_with_friend(sharer, friend_id)
  #   friend = User.find(friend_id)
  #   friend.shared_uploads.find_or_create_by_upload_id_and_shared_by_id(self.id, sharer.id)
  # end
  # 
  # def share_with_group(sharer, group_id)
  #   group = Group.find(group_id)
  #   if group.is_member?(sharer)
  #     shared_upload = group.shared_uploads.find_or_create_by_upload_id_and_shared_by_id(self.id, sharer.id)
  #   end
  #   # TODO decide if we want to feed this into a feed somewhere
  #   shared_upload
  # end
  # 
  # def share_with_friends(user, friend_ids)
  #   friend_ids.each do |friend_id, checked|
  #     self.share_with_friend(user, friend_id) if (checked == "1")
  #   end    
  # end
  # 
  # def share_with_groups(user, group_ids)
  #   group_ids.each do |group_id, checked|
  #     self.share_with_group(user, group_id) if (checked == "1")
  #   end    
  # end
  
end
