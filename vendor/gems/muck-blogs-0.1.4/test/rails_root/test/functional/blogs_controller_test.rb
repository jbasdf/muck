require File.dirname(__FILE__) + '/../test_helper'

class Muck::BlogsControllerTest < ActionController::TestCase

  tests Muck::BlogsController

  context "blogs controller" do
    setup do
      @user = Factory(:user)
      @blog = @user.blog
    end
    
    context "GET show" do
      setup do
        get :show, :id => @blog.id
      end
      should_redirect_to("posts index page") { blog_posts_path(@blog) }
    end

    context "GET show using parent" do
      setup do
        get :show, make_parent_params(@user).merge(:id => @blog.to_param)
      end
      should_redirect_to("posts index page") { user_blog_posts_path(@user) }
    end
    
    context "GET index" do
      setup do
        # create a few blogs to be displayed
        Factory(:blog)
        Factory(:blog)
        get :index
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :index
    end
    
    context "GET index when user only has one blog" do
      setup do
        get :index, make_parent_params(@user)
      end
      should_redirect_to("posts index page") { user_blog_posts_path(@user) }
    end
    
  end
  
end
