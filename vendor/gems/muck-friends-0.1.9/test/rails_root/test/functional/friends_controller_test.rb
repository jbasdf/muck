require File.dirname(__FILE__) + '/../test_helper'

class Muck::FriendsControllerTest < ActionController::TestCase

  tests Muck::FriendsController
  
  context "friends controller" do
    setup do
      @quentin = Factory(:user)
      @aaron = Factory(:user)
    end
    
    context "not logged in" do
      context 'render index page' do
        setup do
          get :index, :user_id => @quentin.to_param
        end
        should_respond_with :success
        should_render_template :index
      end
      
      context "deny access to create" do
        setup do
          post :create, { :id => @aaron.to_param }
        end
        should_redirect_to("login") { login_path }
        should_set_the_flash_to(I18n.t("muck.users.login_requred"))
      end
      
      context "deny access to destroy" do
        setup do
          delete :destroy, { :id => @aaron.to_param }
        end
        should_redirect_to("login") { login_path }
        should_set_the_flash_to(I18n.t("muck.users.login_requred"))
      end
    end

    context "logged in" do
      setup do
        activate_authlogic
        login_as @quentin
      end
      
      context 'render my index page' do
        setup do
          get :index, :user_id => @quentin.to_param
        end
        should_respond_with :success
        should_render_template :index
      end
      
      context "render another user's friend page" do
        setup do
          get :index, :user_id => @aaron.to_param
        end
        should_respond_with :success
        should_render_template :index
      end
      
      context "make a follower (same as send friend request)" do
        setup do
          Friend.destroy_all
          post :create, { :id => @aaron.to_param, :format=>'js' }
        end
        should_respond_with :success
        should_not_set_the_flash
        should "setup relationship" do
          @quentin.reload
          @aaron.reload
          assert !@quentin.friend_of?(@aaron)
          assert @quentin.following?(@aaron)
          assert @aaron.followed_by?(@quentin)
        end
      end
      
      context "make a friendship" do
        setup do
          Friend.destroy_all
          Friend.add_follower(@quentin, @aaron)
          post :create, { :id => @aaron.to_param, :format=>'js'}
        end
        should_respond_with :success
        should_not_set_the_flash
        should "setup friend relationship" do
          @quentin.reload
          @aaron.reload
          assert @quentin.friend_of?(@aaron)
          assert !@quentin.followed_by?(@aaron)
          assert @aaron.friend_of?(@quentin)
          assert !@aaron.followed_by?(@quentin)
        end
      end

      context "update - block user" do
        setup do
          Friend.destroy_all
          Friend.add_follower(@quentin, @aaron)
          Friend.make_friends(@quentin, @aaron)
          post :update, { :id => @aaron.to_param, :block => true, :format=>'js'}
        end
        should_respond_with :success
        should_not_set_the_flash
        should "block user" do
          @quentin.reload
          @aaron.reload
          assert @quentin.blocked?(@aaron)
        end
      end

      context "update - unblock user" do
        setup do
          Friend.destroy_all
          Friend.add_follower(@quentin, @aaron)
          Friend.make_friends(@quentin, @aaron)
          @quentin.block_user(@aaron)
          post :update, { :id => @aaron.to_param, :block => false, :format=>'js'}
        end
        should_respond_with :success
        should_not_set_the_flash
        should "unblock user" do
          @quentin.reload
          @aaron.reload
          assert !@quentin.blocked?(@aaron)
        end
      end
      
      context "error while trying to make an invalid friendship" do
        setup do
          Friend.destroy_all
          post :create, { :id => @quentin.to_param, :format => 'js' }
        end
        should_respond_with :success
        should_not_set_the_flash
        should "not create friendship" do
          @quentin.reload
          @aaron.reload
        end
      end
      
      context "Following allowed" do
        setup do
          @temp_enable_following = GlobalConfig.enable_following
          GlobalConfig.enable_following = true
          Friend.destroy_all
          @aaron.follow(@quentin)
          @quentin.become_friends_with(@aaron)
        end
        teardown do
          GlobalConfig.enable_following = @temp_enable_following
        end
        context 'DELETE to destroy js request' do
          setup do
            delete :destroy, { :user_id => @quentin.to_param, :id => @aaron.to_param, :format => 'js'}
          end
          should_respond_with :success
          should "stop being friends" do
            @quentin.reload
            @aaron.reload
            assert !@quentin.friend_of?(@aaron)
            assert !@quentin.following?(@aaron)
            assert @quentin.followed_by?(@aaron)
          end
        end
        context 'DELETE to destroy  html request' do
          setup do
            delete :destroy, { :user_id => @quentin.to_param, :id => @aaron.to_param}
          end
          should_redirect_to("target's profile") { profile_path(@aaron) }
        end
      end
      
      context 'Following not allowed' do
        setup do
          @temp_enable_following = GlobalConfig.enable_following
          GlobalConfig.enable_following = false
          Friend.destroy_all
          @aaron.follow(@quentin)
          @quentin.become_friends_with(@aaron)          
        end
        teardown do
          GlobalConfig.enable_following = @temp_enable_following
        end
        context 'js request' do
          setup do
            delete :destroy, { :user_id => @quentin.to_param, :id => @aaron.to_param, :format => 'js'}
          end
          should_respond_with :success
          should "stop being friends and not allow following" do
            @quentin.reload
            @aaron.reload
            assert !@aaron.followed_by?(@quentin)
            assert !@quentin.followed_by?(@aaron)
            assert !@aaron.friend_of?(@quentin)
            assert !@quentin.friend_of?(@aaron)
            assert !@aaron.following?(@quentin)
            assert !@quentin.following?(@aaron)
          end
        end
      end
    
    end
  end
end
