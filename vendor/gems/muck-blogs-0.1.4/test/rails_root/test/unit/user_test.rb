require File.dirname(__FILE__) + '/../test_helper'

# Use to test has_muck_blog
class UserTest < ActiveSupport::TestCase

  context "A class that is blogable" do
    should_have_one :blog
    should "automatically create a blog for the user" do
      assert_difference "Blog.count", 1 do
        @user = Factory(:user)
      end
    end
  end

end