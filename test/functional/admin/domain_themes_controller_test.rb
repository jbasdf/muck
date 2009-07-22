require File.dirname(__FILE__) + '/../../test_helper'

class Admin::DomainThemesControllerTest < ActionController::TestCase

  tests Admin::DomainThemesController
  
  should_require_login :create => :post, :update => :put, :destroy => :delete, :login_url => '/login'
  should_require_login :create => :post, :login_url => '/login'
    
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
    end
    context "POST to create" do
      setup do
        post :create, :domain_theme => { :name => 'test', :uri => 'www.example.com' }
      end
      should_redirect_to("admin edit theme") { edit_admin_theme_path }
    end
    context "PUT to update" do
      setup do
        @domain_theme = Factory(:domain_theme)
        put :update, :id => @domain_theme.to_param, :domain_theme => { :name => @domain_theme.name, :uri => 'www.example.com' }
      end
      should_set_the_flash_to(I18n.t('disguise.theme_updated'))
      should_redirect_to("admin edit theme") { edit_admin_theme_path }
    end
    context "DELETE to destroy" do
      setup do
        @domain_theme = Factory(:domain_theme)
        delete :destroy, :id => @domain_theme.to_param
      end
      should_set_the_flash_to(I18n.t('disguise.uri_deleted'))
      should_redirect_to("admin edit theme") { edit_admin_theme_path }
    end
  end
  
end