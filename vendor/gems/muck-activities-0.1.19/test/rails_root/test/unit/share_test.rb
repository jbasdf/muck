# using muck shares to test acts_as_activity_item

require File.dirname(__FILE__) + '/../test_helper'

class ShareTest < ActiveSupport::TestCase
  context "share" do
    setup do
      @user = Factory(:user)
      @share = Factory(:share)
      @share.add_share_activity([@user])
    end
    should_have_many :activities
    should "delete activities if share is deleted" do
      assert_difference "Activity.count", -1 do
        @share.destroy
      end
    end
  end
end