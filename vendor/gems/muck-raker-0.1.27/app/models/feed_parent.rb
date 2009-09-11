# == Schema Information
#
# Table name: feed_parents
#
#  id           :integer(4)      not null, primary key
#  feed_id      :integer(4)
#  ownable_id   :integer(4)
#  ownable_type :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class FeedParent < ActiveRecord::Base
  unloadable
  
  belongs_to :feed
  belongs_to :ownable, :polymorphic => true
end
