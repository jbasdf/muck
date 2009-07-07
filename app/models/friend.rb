class Friend < ActiveRecord::Base
  acts_as_muck_friend
  has_activities
end