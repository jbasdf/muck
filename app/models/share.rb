class Share < ActiveRecord::Base
  acts_as_muck_share
  belongs_to :entry
end