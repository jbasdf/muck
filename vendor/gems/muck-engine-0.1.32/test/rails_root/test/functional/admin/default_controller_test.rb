require File.dirname(__FILE__) + '/../../test_helper'

class Admin::Muck::DefaultControllerTest < ActionController::TestCase

  tests Admin::DefaultController

  context "GET to admin index" do
    setup do
      @controller.stubs(:login_required).returns(true)
      @controller.stubs(:admin_access_required).returns(true)
      get :index
    end
    should_respond_with :success
    should_render_template :index
  end

  # TODO add tests to confirm admin UI access requires login and role 'administrator'
  # context "GET to admin index not logged in" do
  #   setup do
  #     @controller.stubs(:login_required).returns(false)
  #     @controller.stubs(:admin_access_required).returns(false)
  #     get :index
  #   end
  #   should_respond_with :redirect
  # end
  
end
