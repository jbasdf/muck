require File.dirname(__FILE__) + '/../test_helper'

class Muck::IdentityFeedsControllerTest < ActionController::TestCase

  tests Muck::IdentityFeedsController

  context "identity feeds controller" do
    
    setup do
      @user = Factory(:user)
      @service = Factory(:service)
    end
    
    context "GET index" do
      setup do
        get :index, :user_id => @user.to_param
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :index
    end

    context "GET new" do
      setup do
        get :new, :user_id => @user.to_param, :service_id => @service.to_param
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :new
    end
    
    context "POST create using bogus service and bogus uri" do
      setup do
        @service = Factory(:service)
        @uri = 'http://www.example.com'
        post :create, :service_id => @service.to_param, :uri => @uri, :user_id => @user
      end
      should_set_the_flash_to(I18n.t('muck.raker.no_feeds_at_uri'))
      should_respond_with :success
      should_render_template :new
    end

    context "POST create using bogus service and username" do
      setup do
        @service = Factory(:service)
        post :create, :service_id => @service.to_param, :username => 'test', :user_id => @user
      end
      should_set_the_flash_to(I18n.t('muck.raker.no_feeds_from_username'))
      should_respond_with :success
      should_render_template :new
    end
    
    context "POST create using uri" do
      setup do
        @service = Factory(:service)
        @uri = TEST_URI
        post :create, :service_id => @service.to_param, :uri => @uri, :user_id => @user
      end
      should_set_the_flash_to(I18n.t('muck.raker.successfully_added_uri_feed'))
    end
    
    context "POST create using valid service username" do
      setup do
        @service = Factory(:service, :uri_template => TEST_USERNAME_TEMPLATE)
        @username = 'jbasdf'
      end
      context "html" do
        setup do
          post :create, :service_id => @service.to_param, :username => @username, :user_id => @user
        end
        should_set_the_flash_to(I18n.t('muck.raker.successfully_added_username_feed'))
      end
      context "json" do
        setup do
          post :create, :service_id => @service.to_param, :username => @username, :user_id => @user, :format => 'json'
        end
        should_respond_with :success
      end
    end
    
    context "POST create using valid service username - duplicate" do
      setup do
        @service = Factory(:service, :uri_template => TEST_USERNAME_TEMPLATE)
        @username = 'jbasdf'
        post :create, :service_id => @service.to_param, :username => @username, :user_id => @user
        post :create, :service_id => @service.to_param, :username => @username, :user_id => @user
      end
      should_set_the_flash_to(I18n.t('muck.raker.already_added_username_Feed'))
      should_respond_with :success
      should_render_template :new
    end
    
    context "POST create using uri - duplicate" do
      setup do
        @service = Factory(:service)
        @uri = TEST_URI
        post :create, :service_id => @service.to_param, :uri => @uri, :user_id => @user
        post :create, :service_id => @service.to_param, :uri => @uri, :user_id => @user
      end
      should_set_the_flash_to(I18n.t('muck.raker.already_added_uri_Feed'))
      should_respond_with :success
      should_render_template :new
    end
    
  end

end