require File.dirname(__FILE__) + '/../test_helper'

class ActivityFeedTest < ActiveSupport::TestCase
  should_belong_to :activity
  should_belong_to :ownable
end