require File.dirname(__FILE__) + '/../../test_helper'

class Admin::Muck::ProfilesControllerTest < ActionController::TestCase

  tests Admin::Muck::ProfilesController

  should_require_login :edit => :get, :login_url => '/login'
  should_require_role(:admin, '/login', :index)
  
  context "logged in as admin" do
    
    setup do
      @admin = Factory(:user)
      @admin_role = Factory(:role, :rolename => 'administrator')
      @admin.roles << @admin_role
      activate_authlogic
      login_as @admin
    end
    
    context "GET edit" do
      setup do
        get :edit
      end
      should_respond_with :success
      should_render_template :edit
    end

  end

end
