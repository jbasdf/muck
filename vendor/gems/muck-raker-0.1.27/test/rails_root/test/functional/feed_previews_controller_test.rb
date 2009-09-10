require File.dirname(__FILE__) + '/../test_helper'

class Muck::FeedPreviewsControllerTest < ActionController::TestCase

  tests Muck::FeedPreviewsController

  context "feed previews controller" do

    context "GET new" do
      setup do
        get :new
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :new
    end

    context "POST to select_feeds" do
      setup do
        post :select_feeds, :feed => { :uri => TEST_URI }
      end          
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :select_feeds
      should "return feeds for the given uri" do
        assert assigns(:feeds).length > 0
      end
    end
    
  end

end