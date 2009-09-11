require File.dirname(__FILE__) + '/../test_helper'

class IdentityFeedTest < ActiveSupport::TestCase
  context "identity feed" do
    should_belong_to :ownable
    should_belong_to :feed
  end
end
