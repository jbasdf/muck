require File.dirname(__FILE__) + '/../../test_helper'

class Admin::Muck::RolesControllerTest < ActionController::TestCase

  tests Admin::Muck::RolesController

  should_require_login :index => :get, :show => :get, :new => :get, :create => :post, :update => :put, :login_url => '/login'
  # TODO get role test working
  # should_require_role(:admin, '/login', :index => :get)
  
end