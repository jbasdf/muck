require File.dirname(__FILE__) + '/../../test_helper'

class Admin::DomainThemesControllerTest < ActionController::TestCase

  tests Admin::DomainThemesController
  
  should_require_login :create => :post, :update => :put, :destroy => :delete, :login_url => '/login'
    
  context "logged in" do
    setup do
      activate_authlogic
      @user = Factory(:user)
      login_as @user
      post :create
    end
    should_redirect_to("login page") { login_url }
  end
  
  context "logged in as admin" do
    setup do
      activate_authlogic
      @user = Factory(:user)
      @user.add_to_role('administrator')
      login_as @user
      post :create, :domain_theme => { :name => 'test', :uri => 'www.example.com' }
    end
    should_respond_with :success
    should_render_template :edit
  end
  
end