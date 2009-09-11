class Share < ActiveRecord::Base
  unloadable
  acts_as_muck_share
end