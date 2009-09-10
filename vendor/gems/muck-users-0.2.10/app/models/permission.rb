# == Schema Information
#
# Table name: permissions
#
#  id         :integer(4)      not null, primary key
#  role_id    :integer(4)      not null
#  user_id    :integer(4)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Permission < ActiveRecord::Base
  unloadable
  
  belongs_to :user
  belongs_to :role
end
