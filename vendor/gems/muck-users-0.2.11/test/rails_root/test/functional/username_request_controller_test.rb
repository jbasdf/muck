require File.dirname(__FILE__) + '/../test_helper'

class Muck::UsernameRequestControllerTest < ActionController::TestCase

  tests Muck::UsernameRequestController

  context "username request controller" do
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
        post :create, :request_username => { :email => @user.email }
      end
      should "send username" do
        assert_sent_email do |email|
          email.to.include?(@user.email)
        end
      end
      should_redirect_to("login") { login_path }
    end
    context "bad email - fail to send username" do
      setup do
        post :create, :request_username => { :email => 'quentin@bad_email_example.com' }
      end
      should_respond_with :success
      should_render_template :new
    end

  end

end
