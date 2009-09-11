# == Schema Information
#
# Table name: activities
#
#  id               :integer(4)      not null, primary key
#  item_id          :integer(4)
#  item_type        :string(255)
#  template         :string(255)
#  source_id        :integer(4)
#  source_type      :string(255)
#  content          :text
#  title            :string(255)
#  is_status_update :boolean(1)
#  is_public        :boolean(1)      default(TRUE)
#  created_at       :datetime
#  updated_at       :datetime
#  comment_count    :integer(4)      default(0)
#  attachable_id    :integer(4)
#  attachable_type  :string(255)
#

class Activity < ActiveRecord::Base
  acts_as_muck_activity
end
