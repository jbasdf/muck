require File.dirname(__FILE__) + '/../test_helper'

class Muck::ActivationsControllerTest < ActionController::TestCase

  def setup
    @controller = Muck::ActivationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    activate_authlogic
  end
  
  context "activations controller" do
    context "not logged in" do
      setup do
        @password = 'testpass'
        @login = 'testuser'
        @user = Factory(:user, :login => @login, :password => @password, 
                               :password_confirmation => @password, :activated_at => nil)
      end
      context "activate user" do
        setup do
          get :new, :id => @user.perishable_token
        end
        should_set_the_flash_to(/Your account has been activated! You can now login/i)
        should_redirect_to("welcome path") { welcome_user_path(@user) }
        should "be able to login" do
          user_session = UserSession.new(:login => @login, :password => @password)
          assert user_session.save
        end
      end
      context "attempt to activate already activated user" do
        setup do
          @user.activate!
          get :new, :id => @user.perishable_token
        end
        should_set_the_flash_to(/Your account has already been activated. You can log in below/i)
        should_redirect_to("login") { login_path }
      end    
      context "don't activate user without key" do
        setup do
          get :new
        end
        should_set_the_flash_to(/Activation code not found. Please try creating a new account/i)
        should_redirect_to("signup") { new_user_path }
      end  
      context "don't activate user with blank key" do
        setup do
          get :new, :id => ''
        end
        should_set_the_flash_to(/Activation code not found. Please try creating a new account/i)
        should_redirect_to("signup") { new_user_path }
      end
      context "don't activate user with bad key" do
        setup do
          get :new, :id => 'asdfasdfasdf'
        end
        should_set_the_flash_to(/Activation code not found. Please try creating a new account/i)
        should_redirect_to("signup") { new_user_path }
      end
    end

    context "logged in" do
      setup do
        @activated_user = Factory(:user)
        login_as @activated_user
        get :new, :id => @activated_user.perishable_token
      end
      should_redirect_to("already logged in page") { @activated_user }
    end
    
  end
  
end
