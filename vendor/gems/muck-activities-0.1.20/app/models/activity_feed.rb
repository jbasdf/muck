# == Schema Information
#
# Table name: activity_feeds
#
#  id           :integer(4)      not null, primary key
#  activity_id  :integer(4)
#  ownable_id   :integer(4)
#  ownable_type :string(255)
#

class ActivityFeed < ActiveRecord::Base
  unloadable
  
  belongs_to :activity
  belongs_to :ownable, :polymorphic => true
end
