require File.dirname(__FILE__) + '/../test_helper'

# this tests the friends helper methods
class Muck::DefaultControllerTest < ActionController::TestCase

  tests DefaultController

  context "" do
    setup do
      @aaron = Factory(:user)
      @quentin = Factory(:user)
      @follower1 = Factory(:user)
      @follower2 = Factory(:user)
      @friend1 = Factory(:user)
      @friend2 = Factory(:user)
      @friend3 = Factory(:user)
      @mutual_friend1 = Factory(:user)
      @mutual_friend2 = Factory(:user)
      
      # aaron's followers
      @follower1.follow(@aaron)
      @follower2.follow(@aaron)
      
      # aaron's friends
      @friend1.follow(@aaron)
      @friend2.follow(@aaron)
      @friend2.follow(@aaron)
      @aaron.become_friends_with(@friend1)
      @aaron.become_friends_with(@friend2)
      @aaron.become_friends_with(@friend3)
                  
      # mutual friends
      @mutual_friend1.follow(@aaron)
      @mutual_friend2.follow(@aaron)
      @aaron.become_friends_with(@mutual_friend1)
      @aaron.become_friends_with(@mutual_friend2)

      @mutual_friend1.follow(@quentin)
      @mutual_friend2.follow(@quentin)
      @quentin.become_friends_with(@mutual_friend1)
      @quentin.become_friends_with(@mutual_friend2)
      
      @controller.stubs(:current_user).returns(@aaron)
      @controller.stubs(:other_user).returns(@quentin)
    end
    
    context "block user link" do
      context "users have no relationship" do
        setup do
          @controller.stubs(:current_user).returns(@aaron)
          get :block_user_link
        end
        should_respond_with :success
        should_render_template :block_user_link
        should "not have block link in the body" do
          assert !@response.body.include?(I18n.t('muck.friends.block', :user => @quentin.display_name))
          assert !@response.body.include?(I18n.t('muck.friends.unblock', :user => @quentin.display_name))
        end
      end      
      context "logged in as aaron" do
        context "quentin following aaron" do
          setup do
            assert @quentin.follow(@aaron)
            @controller.stubs(:current_user).returns(@aaron)
            get :block_user_link
          end
          should_respond_with :success
          should_render_template :block_user_link
          should "have 'block' in the body" do
            assert @response.body.include?(I18n.t('muck.friends.block', :user => @quentin.display_name))
          end
        end
        context "aaron has blocked quentin" do
          setup do
            assert @quentin.follow(@aaron)
            assert @aaron.block_user(@quentin)
            assert @aaron.blocked?(@quentin)
            @controller.stubs(:current_user).returns(@aaron)
            get :block_user_link
          end
          should_respond_with :success
          should_render_template :block_user_link
          should "have 'unblock' in the body" do
            assert @response.body.include?(I18n.t('muck.friends.unblock', :user => @quentin.display_name))
          end
        end
      end
    end
    
    context "friend link" do
      setup do
        @enable_following = GlobalConfig.enable_following
        @enable_friending = GlobalConfig.enable_friending
      end
      teardown do
        # Reset global config
        GlobalConfig.enable_following = @enable_following
        GlobalConfig.enable_friending = @enable_friending
      end
      
      context "enable_following is true and enable_friending is true" do
        setup do
          GlobalConfig.enable_following = true
          GlobalConfig.enable_friending = true
        end
        context "no current user" do
          setup do
            @controller.stubs(:current_user).returns(nil)
            get :friend_link
          end
          should_respond_with :success
          should_render_template :friend_link
          should "have login/signup in the body" do
            assert @response.body.include?(I18n.t('muck.friends.login'))
          end
        end
        context "current user is not friends with other user" do
          setup do
            @other_user = Factory(:user)
            @controller.stubs(:other_user).returns(@other_user)
            get :friend_link
          end
          should_respond_with :success
          should_render_template :friend_link
          should "have 'follow' in the body" do
            assert @response.body.include?(I18n.t('muck.friends.start_following', :user => @other_user.display_name))
          end
        end
        context "current user is friends with other user" do
          setup do
            @controller.stubs(:other_user).returns(@friend1)
            get :friend_link
          end
          should_respond_with :success
          should_render_template :friend_link
          should "have 'stop being friends' in the body" do
            assert @response.body.include?(I18n.t('muck.friends.stop_being_friends_with', :user => @friend1.display_name))
          end
        end
        context "current user is not friend with other user, but other user follows current user" do
          setup do
            @controller.stubs(:other_user).returns(@follower1)
            get :friend_link
          end
          should_respond_with :success
          should_render_template :friend_link
          should "have 'accept friend request' in the body" do
            assert @response.body.include?(I18n.t('muck.friends.acccept_friend_request', :user => @follower1.display_name))
          end
        end
      end
      
      context "enable_following is true and enable_friending is false" do
        setup do
          GlobalConfig.enable_following = true
          GlobalConfig.enable_friending = false
        end
        context "no current user" do
          setup do
            @controller.stubs(:current_user).returns(nil)
            get :friend_link
          end
          should_respond_with :success
          should_render_template :friend_link
          should "have login/signup in the body" do
            assert @response.body.include?(I18n.t('muck.friends.login'))
          end
        end
        context "current user is not following other user" do
          setup do
            @other_user = Factory(:user)
            @controller.stubs(:other_user).returns(@other_user)
            get :friend_link
          end
          should_respond_with :success
          should_render_template :friend_link
          should "have 'follow' in the body" do
            assert @response.body.include?(I18n.t('muck.friends.start_following', :user => @other_user.display_name))
          end
        end
        context "current user is following the other user" do
          setup do
            @being_followed = Factory(:user)
            @aaron.follow(@being_followed)
            @controller.stubs(:other_user).returns(@being_followed)
            get :friend_link
          end
          should_respond_with :success
          should_render_template :friend_link
          should "have 'stop following' in the body" do
            assert @response.body.include?(I18n.t('muck.friends.stop_following', :user => @being_followed.display_name))
          end
        end
        context "current user is not friend with other user, but other user follows current user" do
          setup do
            @controller.stubs(:other_user).returns(@follower1)
            get :friend_link
          end
          should_respond_with :success
          should_render_template :friend_link
          should "have 'follow' in the body" do
            assert @response.body.include?(I18n.t('muck.friends.start_following', :user => @follower1.display_name))
          end
        end
      end
      
      context "enable_following is false and enable_friending is true" do
        setup do
          GlobalConfig.enable_following = false
          GlobalConfig.enable_friending = true
        end
        context "no current user" do
          setup do
            @controller.stubs(:current_user).returns(nil)
            get :friend_link
          end
          should_respond_with :success
          should_render_template :friend_link
          should "have login/signup in the body" do
            assert @response.body.include?(I18n.t('muck.friends.login'))
          end
        end
        context "current user is not friends with the other user" do
          setup do
            @other_user = Factory(:user)
            @controller.stubs(:other_user).returns(@other_user)
            get :friend_link
          end
          should_respond_with :success
          should_render_template :friend_link
          should "have 'friend request' in the body" do
            assert @response.body.include?(I18n.t('muck.friends.friend_request_prompt', :user => @other_user.display_name))
          end
        end
        context "current user has sent a friend request to the other user" do
          setup do
            @being_followed = Factory(:user)
            @aaron.follow(@being_followed)
            @controller.stubs(:other_user).returns(@being_followed)
            get :friend_link
          end
          should_respond_with :success
          should_render_template :friend_link
          should "have 'friend request pending' in the body" do
            assert @response.body.include?(I18n.t('muck.friends.friend_request_pending', :link => ''))
          end
        end
        context "current user is not friend with other user, but other user has sent a friend request" do
          setup do
            @controller.stubs(:other_user).returns(@follower1)
            get :friend_link
          end
          should_respond_with :success
          should_render_template :friend_link
          should "have 'accept friend request' in the body" do
            assert @response.body.include?(I18n.t('muck.friends.acccept_friend_request', :user => @follower1.display_name))
          end
        end
      end
      
    end

    context 'all friends' do
      setup do
        get :all_friends
      end
      should_respond_with :success
      should_render_template :all_friends
    end

    context 'mutual friends' do
      setup do
        get :mutual_friends
      end
      should_respond_with :success
      should_render_template :mutual_friends
    end
    
    context 'friends' do
      setup do
        get :friends
      end
      should_respond_with :success
      should_render_template :friends
    end
    
    context 'followers' do
      setup do
        get :followers
      end
      should_respond_with :success
      should_render_template :followers
    end
    
    context 'followings' do
      setup do
        get :followings
      end
      should_respond_with :success
      should_render_template :followings
    end
    
    context 'friend requests' do
      setup do
        @enable_following = GlobalConfig.enable_following
        GlobalConfig.enable_following = false
        get :friend_requests
      end
      teardown do
        GlobalConfig.enable_following = @enable_following
      end
      should_respond_with :success
      should_render_template :friend_requests
    end
    
  end
end