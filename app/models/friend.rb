# == Schema Information
#
# Table name: friends
#
#  id         :integer(4)      not null, primary key
#  inviter_id :integer(4)
#  invited_id :integer(4)
#  status     :integer(4)      default(0)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_friends_on_inviter_id_and_invited_id  (inviter_id,invited_id)
#  index_friends_on_invited_id_and_inviter_id  (invited_id,inviter_id)
#

class Friend < ActiveRecord::Base
  acts_as_muck_friend
  has_activities
end
