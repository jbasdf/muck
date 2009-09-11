require File.dirname(__FILE__) + '/../test_helper'

class Muck::CommentsControllerTest < ActionController::TestCase

  tests Muck::CommentsController

  context "comments controller" do
    setup do
      @user = Factory(:user)
    end
    
    context "GET new" do
      setup do
        get :new, make_parent_params(@user)
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :new
    end

    context "GET index using comment" do
      setup do
        @comment = Factory(:comment, :commentable => @user)
        child = Factory(:comment, :commentable => @user)
        child.move_to_child_of(@comment)
        get :index, :format => 'html', :id => @comment.id
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :index
    end
      
    context "GET index using parent" do
      setup do
        # create a few comments to be displayed
        comment = Factory(:comment, :commentable => @user)
        child = Factory(:comment, :commentable => @user)
        child.move_to_child_of(comment)
        get :index, make_parent_params(@user).merge(:format => 'html')
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :index
    end
  
    context "logged in" do
      setup do
        activate_authlogic
        login_as @user
        @comment = Factory(:comment, :user => @user)
      end
      context "delete comment" do
        should "delete comment" do
          assert_difference "Comment.count", -1 do
            delete :destroy, { :id => @comment.to_param, :format => 'json' }          
            assert @response.body.include?(I18n.t('muck.comments.comment_removed'))
          end
        end
      end
    end
    
    context "create comment" do
      should " be able to create a comment" do
        assert_difference "Comment.count" do
          post :create,  make_parent_params(@user).merge(:format => 'json', :comment => { :body => 'test' })
        end
      end
    end
    
  end
  
end
