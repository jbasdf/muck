require File.dirname(__FILE__) + '/../test_helper'

# Used to test muck_friend
class FriendTest < ActiveSupport::TestCase

  context "A Friend instance" do    
    should_belong_to :inviter
    should_belong_to :invited
  end
  
  context "friending" do
    setup do
      @aaron = Factory(:user)
      @quentin = Factory(:user)
      @friend_guy = Factory(:user)
      @follower_guy = Factory(:user)
    end

    context "No entries in friends" do
      setup do
        Friend.destroy_all
      end
      should "be able to start and stop following aaron" do
        assert !@friend_guy.following?(@aaron)
        assert_difference "Friend.count" do
          Friend.add_follower(@friend_guy, @aaron)
          @aaron.reload
          @friend_guy.reload
          assert @friend_guy.following?(@aaron)
        end
        assert_difference "Friend.count", -1 do
          Friend.stop_following(@friend_guy, @aaron)
          @aaron.reload and @friend_guy.reload
          assert !@friend_guy.following?(@aaron)
        end
      end

      should "not have any effect on friends" do
        assert_no_difference "Friend.count" do        
          assert !Friend.stop_following(@friend_guy, @aaron)
        end
        assert_no_difference "Friend.count" do        
          assert Friend.stop_being_friends(@friend_guy, @aaron) # will return true as long as no friend entries are found for the given users
        end
      end
    
      should "not create an association with the same user" do
        assert !Friend.add_follower(@quentin, @quentin)
        assert_equal 0, Friend.count
      end

      should "create a new follower" do
        assert Friend.add_follower(@quentin, @aaron)
        assert_equal 1, Friend.count
        assert !@quentin.reload.friend_of?(@aaron.reload)
        assert @quentin.following?(@aaron)
        assert @aaron.followed_by?(@quentin)
      end

      should "not find a following to turn into a friendship so just makes a follower" do
        assert Friend.make_friends(@quentin, @aaron)
        assert_equal 1, Friend.count
        assert !@quentin.reload.friend_of?(@aaron.reload)
        assert @quentin.following?(@aaron)
        assert @aaron.followed_by?(@quentin)
      end

      should "turn a following into a friendship" do
        assert Friend.add_follower(@quentin, @aaron)
        assert_equal 1, Friend.count
        assert Friend.make_friends(@aaron, @quentin)
        assert_equal 2, Friend.count
        @quentin.reload
        @aaron.reload
        assert @quentin.friend_of?(@aaron)
        assert @aaron.friend_of?(@quentin)
      end

      should "turn a following into a friendship with reversed users" do
        assert Friend.add_follower(@quentin, @aaron)
        assert_equal 1, Friend.count
        assert Friend.make_friends(@quentin, @aaron)
        assert_equal 2, Friend.count
        @quentin.reload
        @aaron.reload
        assert @quentin.friend_of?(@aaron)
        assert @aaron.friend_of?(@quentin)
      end

      should "not find a friendship so can't stop being friends" do
        assert !Friend.revert_to_follower(@quentin, @aaron) # revert_to_follower will return true as long as the desired state (reverted to follower) is achieved.
      end

      should "revert to follower" do
        assert Friend.add_follower(@quentin, @aaron)
        assert Friend.make_friends(@quentin, @aaron)
        assert_equal 2, Friend.count
        @quentin.reload
        @aaron.reload
        assert Friend.revert_to_follower(@quentin, @aaron)
        assert_equal 1, Friend.count
        @quentin.reload
        @aaron.reload
        assert !@quentin.friend_of?(@aaron)
        assert !@quentin.following?(@aaron)
        assert @quentin.followed_by?(@aaron)
        assert !@aaron.friend_of?(@quentin)
        assert @aaron.following?(@quentin)
        assert !@aaron.followed_by?(@quentin)
      end

      should "stop being friends" do
        assert Friend.add_follower(@quentin, @aaron)
        assert Friend.make_friends(@quentin, @aaron)
        assert_equal 2, Friend.count
        @quentin.reload
        @aaron.reload
        assert Friend.stop_being_friends(@quentin, @aaron)
        @quentin.reload
        @aaron.reload
        assert !@quentin.friend_of?(@aaron)
        assert !@quentin.following?(@aaron)
        assert !@quentin.followed_by?(@aaron)
        assert !@aaron.friend_of?(@quentin)
        assert !@aaron.following?(@quentin)
        assert !@aaron.followed_by?(@quentin)
      end

      should "block friend" do
        assert Friend.add_follower(@quentin, @aaron)
        assert Friend.make_friends(@quentin, @aaron)
        Friend.block_user(@quentin, @aaron)
        assert @quentin.blocked_users.include?(@aaron)
        assert !@quentin.friend_of?(@aaron)
        assert !@quentin.followed_by?(@aaron)
        assert !@quentin.following?(@aaron)
        assert !@aaron.friend_of?(@quentin)
        assert !@aaron.followed_by?(@quentin)
        assert !@aaron.following?(@quentin)
      end
    
      should "block follower" do
        assert Friend.add_follower(@quentin, @aaron)
        Friend.block_user(@aaron, @quentin)
        assert @aaron.blocked_users.include?(@quentin)
        assert !@quentin.friend_of?(@aaron)
        assert !@quentin.following?(@aaron)
        assert !@aaron.friend_of?(@quentin)
        assert !@aaron.following?(@quentin)
        assert !@aaron.followed_by?(@quentin)
      end
      
      should "show if user is blocked" do
        assert Friend.add_follower(@quentin, @aaron)
        Friend.block_user(@aaron, @quentin)
        assert Friend.blocked?(@aaron, @quentin)
      end
      
    end
    
    should "ignore block user request" do
      assert !Friend.block_user(nil, nil)
    end
    
    context "activities" do
      setup do
        @temp_enable_friend_activity = GlobalConfig.enable_friend_activity
        GlobalConfig.enable_friend_activity = true
      end
      teardown do
        GlobalConfig.enable_friend_activity = @temp_enable_friend_activity
      end
      should "add follow activity" do
        assert_difference "Activity.count", 1 do
          Friend.add_follower(@quentin, @aaron)
        end
      end
      should "add friends with activity" do
        assert_difference "Activity.count", 1 do
          Friend.make_friends(@quentin, @aaron)
        end
      end
    end
  end
  
end