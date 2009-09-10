require File.dirname(__FILE__) + '/../test_helper'

class Muck::ProfilesControllerTest < ActionController::TestCase

  tests Muck::ProfilesController

  context "GET show" do
    setup do
      @user = Factory(:user)
      get :show, :id => @user.to_param
    end
    should_respond_with :success
    should_render_template :show
  end

end
