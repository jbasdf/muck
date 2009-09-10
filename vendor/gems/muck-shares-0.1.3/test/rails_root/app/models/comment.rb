class Comment < ActiveRecord::Base
  acts_as_muck_comment
  acts_as_activity_source
end