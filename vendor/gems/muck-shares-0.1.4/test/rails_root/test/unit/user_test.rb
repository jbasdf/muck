require File.dirname(__FILE__) + '/../test_helper'

# Used to test muck_friend_user
class UserTest < ActiveSupport::TestCase

  context "A user that can share" do
    
    should_have_many :shares
    
    setup do
      @user = Factory(:user)
      @share = @user.shares.build(Factory.attributes_for(:share))
      @share.save!
    end
    
    should "have shares" do
      assert_equal 1, @user.shares.length
    end
    # TODO can add the count cache later on if we need it
    # should "have share cache" do
    #   @user.reload
    #   assert_equal 1, @user.share_count
    # end
  end

end