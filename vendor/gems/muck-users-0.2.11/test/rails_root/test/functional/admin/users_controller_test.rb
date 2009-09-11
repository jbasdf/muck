require File.dirname(__FILE__) + '/../../test_helper'

class Admin::Muck::UsersControllerTest < ActionController::TestCase

  tests Admin::Muck::UsersController

  # TODO get role test working
  # should_require_role(:admin, '/login', :index => :get)
  should_require_login :index => :get, :inactive => :get, :inactive_emails => :get, :activate_all => :get, :search => :get, :login_url => '/login'

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
      should_respond_with :success
      should_render_template :index
    end

    context "GET inactive" do
      setup do
        get :inactive
      end
      should_respond_with :success
      should_render_template :inactive
    end
    
    context "GET search" do
      setup do
        get :search
      end
      should_respond_with :success
      should_render_template :index
    end

    context "GET ajax search" do
      setup do
        get :ajax_search
      end
      should_respond_with :success
      should_render_template :table
    end    
    
    context 'on DELETE to :destroy' do
      setup do
        @user = Factory(:user)
        delete :destroy, {:id => @user.to_param}
      end
      should_redirect_to("Main user screen") { admin_users_path }
    end

  end

end
