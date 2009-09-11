require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  context "activities" do
    setup do
      @user = Factory(:user)
    end
    should_have_many :activity_feeds
    should_have_many :activities
    should "create an activity" do
      assert_difference "Activity.count", 1 do
        @user.add_activity(@user.feed_to, @user, @user, 'status_update', 'status', 'a status update')
      end
    end
    should "set the user's current status" do
      activity = @user.add_activity(@user.feed_to, @user, @user, 'status_update', 'status', 'a status update')
      activity.is_status_update = true
      activity.save!
      assert_equal @user.status, activity
    end
  end
end