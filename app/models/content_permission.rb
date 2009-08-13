# == Schema Information
#
# Table name: content_permissions
#
#  id         :integer(4)      not null, primary key
#  content_id :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_content_permissions_on_content_id_and_user_id  (content_id,user_id)
#

class ContentPermission < ActiveRecord::Base
  acts_as_muck_content_permission
end
