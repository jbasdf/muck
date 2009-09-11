require File.dirname(__FILE__) + '/../test_helper'

# Used to test muck_friend_user
class UserTest < ActiveSupport::TestCase

  context "A class that is commentable" do
    setup do
      @user = Factory(:user)
      @comment = @user.comments.build(:body => 'a test comment')
      @comment.user = @user
      @comment.save!
    end
    
    should "have comments" do
      assert_equal 1, @user.comments.length
    end
    should "have comment cache" do
      @user.reload
      assert_equal 1, @user.comment_count
    end
  end

end