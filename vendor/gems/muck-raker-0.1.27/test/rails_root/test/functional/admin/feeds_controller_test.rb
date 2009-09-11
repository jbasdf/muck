require File.dirname(__FILE__) + '/../../test_helper'

class Admin::Muck::FeedsControllerTest < ActionController::TestCase

  tests Admin::Muck::FeedsController

  context "admin feeds controller" do
    
    should_require_login :index => :get, :update => :put, :login_url => '/login'
    
    context "logged in as admin" do
      setup do
        @admin = Factory(:user)
        @admin_role = Factory(:role, :rolename => 'administrator')
        @admin.roles << @admin_role
        activate_authlogic
        login_as @admin
      end
      context "GET index" do
        setup do
          get :index
        end
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :index
      end
      context "PUT update" do
        setup do
          @feed = Factory(:feed)
          put :update, :id => @feed, :status => true
        end
        should_redirect_to("feed index") { admin_feeds_path } 
      end
    end
  end

end