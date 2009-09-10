require File.dirname(__FILE__) + '/../test_helper'

class Muck::UserSessionsControllerTest < ActionController::TestCase

  tests Muck::UserSessionsController

  should_filter_params :password
  
  context "user sessions controller" do
    setup do
      @login = 'quentin'
      @good_password = 'test'
      @user = Factory(:user, :login => @login, :password => @good_password, :password_confirmation => @good_password)
    end
    context "get new" do
      setup do
        get :new
      end
      should_respond_with :success
      should_render_template :new
    end
    context "login and redirect" do
      setup do
        post :create, :user_session => { :login => @login, :password => @good_password }
      end
      should "create a user session" do
        assert user_session = UserSession.find
        assert_equal @user, user_session.user        
      end
      should_redirect_to("user account") { user_path(@user) }
    end
    context "fail login" do
      setup do
        post :create, :user_session => { :login => @login, :password => 'bad password' }
      end
      should "not create a user session" do
        assert_nil UserSession.find
      end
      should_respond_with :success
      should_render_template :new
    end

    context "authlogic enabled" do
      setup do
        @user = Factory(:user)
        activate_authlogic
      end
      context "logout" do
        setup do
          login_as(@user)
          delete :destroy
        end
        should "logout by destroying the user session" do
          assert_nil UserSession.find
        end
        should_redirect_to("logout complete path") { logout_complete_path }
      end
    end
    
  end

end
