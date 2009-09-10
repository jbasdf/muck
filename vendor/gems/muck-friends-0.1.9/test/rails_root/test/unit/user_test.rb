require File.dirname(__FILE__) + '/../test_helper'

# Used to test muck_friend_user
class UserTest < ActiveSupport::TestCase

  context "user instance with acts_as_muck_friend_user" do
    should_have_many :friendships
    should_have_many :follower_friends
    should_have_many :following_friends
    should_have_many :blocked_friends

    should_have_many :friends
    should_have_many :followers
    should_have_many :followings
    should_have_many :blocked_users

    should_have_many :initiated_by_me
    should_have_many :not_initiated_by_me
    
    should_have_many :friendships_initiated_by_me
    should_have_many :friendships_not_initiated_by_me
    
    should_have_many :occurances_as_friend
  end

  context "user as friend" do
    setup do
      Friend.destroy_all
      @aaron = Factory(:user)
      @quentin = Factory(:user)
      @friend_guy = Factory(:user)
      @follower_guy = Factory(:user)
    end

    context "following disabled" do
      setup do
        @temp_enable_following = GlobalConfig.enable_following
        GlobalConfig.enable_following = false
      end
      teardown do
        GlobalConfig.enable_following = @temp_enable_following
      end
      should "stop being friends" do
        assert @quentin.follow(@aaron)
        assert @aaron.become_friends_with(@quentin)
        assert @quentin.drop_friend(@aaron)
        @quentin.reload
        @aaron.reload
        assert !@quentin.friend_of?(@aaron)
        assert !@quentin.following?(@aaron)
        assert !@quentin.followed_by?(@aaron)
        assert !@aaron.friend_of?(@quentin)
        assert !@aaron.following?(@quentin)
        assert !@aaron.followed_by?(@quentin)
      end
      context "drop_friend following not enabled" do
        setup do
          assert @quentin.follow(@aaron)
          assert @aaron.become_friends_with(@quentin)
          assert @quentin.drop_friend(@aaron)
        end
        should "stop being friends with the user and don't retain follow" do
          assert !@quentin.followings.any?{|f| f.id == @aaron.id}
          assert !@aaron.followings.any?{|f| f.id == @quentin.id}
        end
      end
    end

    context "following enabled" do
      setup do
        @temp_enable_following = GlobalConfig.enable_following
        GlobalConfig.enable_following = true
      end
      teardown do
        GlobalConfig.enable_following = @temp_enable_following
      end
      should "stop being friends but still allow follow" do
        assert @quentin.follow(@aaron)
        assert @aaron.become_friends_with(@quentin)
        assert @quentin.drop_friend(@aaron)
        @quentin.reload
        @aaron.reload
        assert !@quentin.friend_of?(@aaron)
        assert !@quentin.following?(@aaron)
        assert @quentin.followed_by?(@aaron)
        assert !@aaron.friend_of?(@quentin)
        assert @aaron.following?(@quentin)
        assert !@aaron.followed_by?(@quentin)
      end
      
      context "drop_friend" do
        setup do
          assert @quentin.follow(@aaron)
        end
        should "stop following the other user but retain follow for other user " do
          assert @aaron.become_friends_with(@quentin)
          assert @quentin.drop_friend(@aaron)
          assert !@quentin.followings.any?{|f| f.id == @aaron.id}
          assert @aaron.followings.any?{|f| f.id == @quentin.id}
        end
        should "stop being friends with the user but retain follow for other user" do
          assert !@quentin.drop_friend(@aaron) # @aaron wasn't following @quentin so drop_friend will return false indicating that a friend object wasn't found to let @aaron continue following @quentin
          assert !@quentin.followings.any?{|f| f.id == @aaron.id}
        end
      end

      should "have friends" do
        assert @aaron.follow(@quentin)
        assert @quentin.become_friends_with(@aaron)
        assert @friend_guy.follow(@quentin)
        assert @quentin.become_friends_with(@friend_guy)
        @quentin.reload
        @aaron.reload
        @friend_guy.reload
        assert @quentin.friends.any?{|f| f.id == @aaron.id || f.id == @friend_guy.id}
        assert @aaron.friends.any?{|f| f.id == @quentin.id}
        assert @friend_guy.friends.any?{|f| f.id == @quentin.id}
      end

      should "not have follower as friend" do
        assert @follower_guy.follow(@quentin)
        assert !@quentin.friends.any?{|f| f.id == @follower_guy.id}
      end

      should "have followers" do
        assert @follower_guy.follow(@quentin)
        assert @quentin.followers.any?{|f| f.id == @follower_guy.id}
      end

      should "have people user follows (followings)" do
        assert @follower_guy.follow(@quentin)
        assert @follower_guy.followings.any?{|f| f.id == @quentin.id}
      end

      should "be a friend" do
        assert @quentin.follow(@aaron)
        assert @quentin.follow(@friend_guy)
        assert @aaron.become_friends_with(@quentin)
        assert @friend_guy.become_friends_with(@quentin)
        assert_equal @quentin.occurances_as_friend.count, 2
      end

      should "find friendships initiated by me" do
        assert @quentin.follow(@aaron)
        assert @quentin.follow(@friend_guy)
        assert_equal 2, @quentin.friendships_initiated_by_me.count
        assert @quentin.friendships_initiated_by_me.any?{|f| f.id == @aaron.id || f.id == @friend_guy.id}
      end

      should "find friendships not initiated by me" do
        assert @aaron.follow(@quentin)
        assert @friend_guy.follow(@quentin)
        assert_equal 2, @quentin.friendships_not_initiated_by_me.count
        assert @quentin.friendships_not_initiated_by_me.any?{|f| f.id == @aaron.id || f.id == @friend_guy.id}
      end

      should "follow the user" do
        assert @quentin.follow(@aaron)
        assert @quentin.followings.any?{|f| f.id == @aaron.id}
      end

      should "stop following the user" do
        assert @quentin.follow(@aaron)
        assert @quentin.stop_following(@aaron)
        assert !@quentin.followings.any?{|f| f.id == @aaron.id}
      end

      should "become friends" do
        assert @quentin.follow(@aaron)
        assert @aaron.become_friends_with(@quentin)
        @quentin.reload
        @aaron.reload
        assert @aaron.friends.any?{|f| f.id == @quentin.id}
        assert @quentin.friends.any?{|f| f.id == @aaron.id}
      end

      should "not have a network" do
        assert !@quentin.has_network?
      end

      should "have a network" do
        assert @quentin.follow(@aaron)
        assert @quentin.has_network?
      end

      should "block user" do
        assert @quentin.follow(@aaron)
        assert @aaron.block_user(@quentin)
        assert !@aaron.friends.any?{|f| f.id == @quentin.id}
        assert !@aaron.followers.any?{|f| f.id == @quentin.id}
        assert !@quentin.followings.any?{|f| f.id == @aaron.id}
        assert @aaron.blocked?(@quentin)
      end

      should "unblock user" do
        assert @quentin.follow(@aaron)
        assert @aaron.block_user(@quentin)
        assert @aaron.unblock_user(@quentin)
        assert @aaron.followers.any?{|f| f.id == @quentin.id}
        assert @quentin.followings.any?{|f| f.id == @aaron.id}
        assert !@aaron.blocked?(@quentin)
      end
      
      should "have friend relation" do
        assert @quentin.follow(@aaron)
        assert @aaron.friendship_with(@quentin)
      end
      
      should "not have friend relation" do
        assert !@quentin.friendship_with(@aaron)
      end
      
    end
    
  end

end