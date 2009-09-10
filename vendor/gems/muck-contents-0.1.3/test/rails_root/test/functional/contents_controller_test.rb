require File.dirname(__FILE__) + '/../test_helper'

class Muck::ContentsControllerTest < ActionController::TestCase

  tests Muck::ContentsController
  
  context "content controller" do
    setup do
      @user = Factory(:user)
      @content = Factory(:content, :contentable => @user)
    end
    
    context "GET show" do
      setup do
        get :show, :id => @content.to_param, :scope => Content.contentable_to_scope(@user)
      end
      should_respond_with :success
      should_render_template :show
    end
    
    context "GET show nested" do
      setup do
        @nested_content = Factory.build(:content, :contentable => nil)
        @nested_content.uri = '/a/test/the_blue_one'
        @nested_content.save!
        get :show, :id => @nested_content.to_param, :scope => @nested_content.scope
      end
      should_respond_with :success
      should_render_template :show
    end
    
    context "GET show using parent" do
      setup do
        get :show, make_parent_params(@user).merge(:id => @content.to_param)
      end
      should_respond_with :success
      should_render_template :show
    end
    
  end
end
