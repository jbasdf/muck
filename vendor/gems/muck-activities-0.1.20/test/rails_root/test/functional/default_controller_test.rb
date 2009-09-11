require File.dirname(__FILE__) + '/../test_helper'

class DefaultControllerTest < ActionController::TestCase

  tests DefaultController

  context "default controller" do
    setup do
      activate_authlogic
      @user = Factory(:user)      
      login_as @user
    end

    context 'on GET to index' do
      # The default view calls the helpers.  This isn't a great test but
      # it will make sure they don't blow up
      setup do
        @user.activities << Factory(:activity,  :template => 'status_update')
        @user.activities << Factory(:activity,  :template => 'status_update')
        get :index
      end
      should_respond_with :success
    end

  end

end
