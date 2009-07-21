require File.dirname(__FILE__) + '/../../test_helper'

class Admin::ThemesControllerTest < ActionController::TestCase

  tests Admin::ThemesController
  
  should_require_login :edit => :get, :update => :put, :login_url => '/login'
    
  context "logged in" do
    setup do
      activate_authlogic
      @user = Factory(:user)
      login_as @user
      get :edit
    end
    should_redirect_to("login page") { login_url }
  end
  
  context "logged in as admin" do
    setup do
      activate_authlogic
      @user = Factory(:user)
      @user.add_to_role('administrator')
      login_as @user
      get :edit
    end
    should_respond_with :success
    should_render_template :edit
  end
  
end