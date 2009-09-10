require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase
  
  context "Comment" do
    setup do
      @user = Factory(:user)
      @comment = @user.comments.build(:body => 'a test comment')
      @comment.user = @user
      @comment.save!
    end
    
    should_validate_presence_of :body
    should_belong_to :user
    should_belong_to :commentable
    
    should_have_named_scope :by_newest
    should_have_named_scope :by_oldest
    should_have_named_scope :recent
    
    should "require body" do
      assert_no_difference 'Comment.count' do
        u = Factory.build(:comment, :body => nil)
        assert !u.valid?
        assert u.errors.on(:body)
      end
    end
        
    should "not have a parent if it is a root Comment" do
      assert_nil @comment.parent
    end

    should " be able to see how many child Comments it has" do
      assert_equal @comment.children.size, 0
    end

    should "be able to add child Comments" do
      # Set commentable to be the same for each comment or else you will get 'Impossible move, target node cannot be inside moved tree.' since the comments would be in a different scope.  (Comments are scoped to commentable)
      parent = Factory(:comment, :commentable => @user)
      child = Factory(:comment, :commentable => @user)
      child.move_to_child_of(parent)
      assert_equal parent.children.size, 1
    end    

    context "after having a child added" do
      setup do
        # Set commentable to be the same for each comment or else you will get 'Impossible move, target node cannot be inside moved tree.' since the comments would be in a different scope.  (Comments are scoped to commentable)
        @child = Factory(:comment, :commentable => @user)
        @child.move_to_child_of(@comment)
      end
    
      should "be able to be referenced by its child" do
        assert_equal @child.parent, @comment
      end
    
      should "be able to see its child" do
        assert_equal @comment.children.first, @child
      end
    end
    
  end

end