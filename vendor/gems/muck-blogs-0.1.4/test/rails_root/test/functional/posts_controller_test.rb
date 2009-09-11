require File.dirname(__FILE__) + '/../test_helper'

class Muck::PostsControllerTest < ActionController::TestCase

  tests Muck::PostsController

  context "posts controller" do
    setup do
      @user = Factory(:user)
      @blog = @user.blog
      @post = Factory(:content, :contentable => @blog)
      @post_too = Factory(:content, :contentable => @blog)
    end

    context "GET show" do
      setup do
        get :show, :id => @post.to_param, :blog_id => @blog.id
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :show
    end
    
    context "GET nested show with numeric post id" do
      setup do
        get :show, :id => @post.id, :user_id => @user.to_param
      end
      should_not_set_the_flash
      should_respond_with 301 # will do a permanent redirect since we called show with a numeric id
    end
    
    context "GET nested show" do
      setup do
        get :show, :id => @post.to_param, :user_id => @user.to_param
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :show
    end
    
    context "GET show using parent and blog" do
      setup do
        get :show, make_parent_params(@user).merge(:id => @post.to_param)
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :show
    end
    
    context "GET index using user as parent object" do
      setup do
        get :index, make_parent_params(@user)
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :index
    end
    
    
    context "GET index using user_id" do
      setup do
        get :index, :user_id => @user.to_param
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :index
    end
    
  end
  
end
