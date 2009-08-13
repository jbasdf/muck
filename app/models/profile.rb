# == Schema Information
#
# Table name: profiles
#
#  id                 :integer(4)      not null, primary key
#  user_id            :integer(4)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#

class Profile < ActiveRecord::Base
  acts_as_muck_profile
end
