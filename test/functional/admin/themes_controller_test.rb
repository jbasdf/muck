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
    end
    
    context "GET edit" do
      setup do
        get :edit
      end
      should_respond_with :success
      should_render_template :edit
    end
    
    context "PUT update" do
      setup do
        put :update, :theme => { :name => 'folksemantic' }
      end
      should_redirect_to("edit admin them page") { edit_admin_theme_path }
      should "add folksemantic default content directory" do
        found = false
        CmsLite.cms_routes.each do |route|
          if route[:content_key] == '/default' && route[:uri] == '/default/*content_page'
            found = true
          end
        end
        assert found
      end
    end
    
  end
  
end