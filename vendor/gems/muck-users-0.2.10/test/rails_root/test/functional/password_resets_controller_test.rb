require File.dirname(__FILE__) + '/../test_helper'

class Muck::PasswordResetsControllerTest < ActionController::TestCase

  tests Muck::PasswordResetsController

   context "password reset controller" do
     setup do
       @user = Factory(:user)
     end
    context "get new" do
      setup do
        get :new
      end
      should_respond_with :success
      should_render_template :new
    end
    context "find user using email and send email message" do
      setup do
        post :create, :reset_password => { :email => @user.email } 
      end
      should "send password reset instructions" do
        assert_sent_email do |email|
          email.to.include?(@user.email)
        end
      end      
      should_redirect_to("login") { login_path }
    end
    context "bad email - fail to reset password" do
      setup do
        post :create, :reset_password => { :email => 'quentin@bad_email_example.com' }
      end
      should_respond_with :success
      should_render_template :new
    end
    context "inactive user - send password not active instructions" do
      setup do
        @inactive_user = Factory(:user, :activated_at => nil)
        post :create, :reset_password => { :email => @inactive_user.email }
      end
      should "send password not active instructions" do
        assert_sent_email do |email|
          email.to.include?(@inactive_user.email)
        end
      end
      should_redirect_to("login") { login_path }
    end
    context "get edit" do
      setup do
        get :edit, :id => @user.perishable_token
      end
      should_respond_with :success
      should_render_template :edit
    end
    context "PUT update" do
      setup do
        put :update, :id => @user.perishable_token, :user => {:password => "foobar", :password_confirmation => "foobar" }
      end
      should_redirect_to("user account") { account_path }
    end
    context "PUT update - password mismatch" do
      setup do
        put :update, :id => @user.perishable_token, :user => {:password => "foobar", :password_confirmation => "foobarbaz"}
      end
      should "fail to update user password because passwords do not match" do
        assert assigns(:user).errors.on(:password)
      end
      should_respond_with :success
      should_render_template :edit
    end
  end
end
