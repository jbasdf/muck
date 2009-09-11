require File.dirname(__FILE__) + '/../test_helper'

class CmsLiteControllerTest < ActionController::TestCase

  tests CmsLiteController

  context "cms lite controller" do
    context "unprotected pages" do
      setup do
        get :show_page, :content_key => 'open', :content_page => ['hello']
      end
      should_respond_with :success
    end
    
    context "unprotected root pages" do
      setup do
        get :show_page, :content_key => '/default', :content_page => 'root'
      end
      should_respond_with :success
    end
    
    context "protected pages"do
      context "not logged in" do
        setup do
          get :show_protected_page, :content_key => 'protected', :content_page => ['safe-hello']
        end
        should_redirect_to("login") { login_path }
      end
      context "logged in" do
        setup do
          activate_authlogic
          @user = Factory(:user)
          login_as @user
          get :show_protected_page, :content_key => 'protected', :content_page => ['safe-hello']
        end
        should_respond_with :success
      end
    end
    
  end

end
