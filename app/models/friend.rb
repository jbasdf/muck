class Friend < ActiveRecord::Base
  
  acts_as_muck_friend
  has_activities
  after_create :add_activity

end