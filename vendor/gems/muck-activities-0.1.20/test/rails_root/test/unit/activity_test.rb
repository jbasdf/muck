require File.dirname(__FILE__) + '/../test_helper'

class ActivityTest < ActiveSupport::TestCase

  context 'An Activity' do
    
    should_validate_presence_of :source
    
    should_belong_to :item
    should_belong_to :source
    should_have_many :activity_feeds
    should_have_many :comments
    
    should_have_named_scope :since
    should_have_named_scope :before
    should_have_named_scope :newest
    should_have_named_scope :oldest
    should_have_named_scope :latest
    should_have_named_scope :only_public
    should_have_named_scope :filter_by_template
    #should_have_named_scope :created_by Throws an exception.  Test below
    should_have_named_scope :status_updates
    should_have_named_scope :by_item
  end

  context "named scopes" do
    setup do
      @user = Factory(:user)
      @old_activity = Factory(:activity, :created_at => 6.weeks.ago)
      @new_activity = Factory(:activity)
      @status_activity = Factory(:activity, :template => 'status')
      @other_activity = Factory(:activity, :template => 'other')
      @private_activity = Factory(:activity, :is_public => false)
      @public_activity = Factory(:activity, :is_public => true)
      @item_activity = Factory(:activity, :item => @user)
      @source_activity = Factory(:activity, :source => @user)
    end
    context "before" do
      should "only find old activity" do
        activities = Activity.before(1.week.ago)
        assert activities.include?(@old_activity), "since didn't find older activity"
        assert !activities.include?(@new_activity), "since found new activity"
      end
    end
    context "since" do
      should "only find new activity" do
        activities = Activity.since(1.week.ago)
        assert !activities.include?(@old_activity), "since found older activity"
        assert activities.include?(@new_activity), "since didn't find new activity"
      end
    end
    context "filter_by_template" do
      should "only find status template" do
        activities = Activity.filter_by_template('status')
        assert activities.include?(@status_activity), "since didn't find status activity"
        assert !activities.include?(@other_activity), "since found other activity"
      end
    end
    context "public" do
      should "only find public activities" do
        activities = Activity.only_public
        assert activities.include?(@public_activity), "only_public didn't find public activity"
        assert !activities.include?(@private_activity), "only_public found private activity"
      end
    end
    context "by_item" do
      should "find activities by the item they are associated with" do
        activities = Activity.by_item(@user)
        assert activities.include?(@item_activity), "by_item didn't find item activity"
        assert !activities.include?(@public_activity), "by_item found public activity"
      end
    end
    context "created_by" do
      should "find activities by the source they are associated with" do
        activities = Activity.created_by(@user)
        assert activities.include?(@source_activity), "created_by didn't find source activity"
        assert !activities.include?(@public_activity), "created_by found public activity"
      end
    end
  end

  should "require template or item" do
    activity = Factory.build(:activity, :template => nil, :item => nil)
    assert !activity.valid?
  end

  should "get the partial from the template" do
    template = 'status_update'
    activity = Factory(:activity, :template => template, :item => nil)
    assert activity.partial == template, "The activity partial was not set to the specified template"
  end

  should "get the partial from the item" do
    user = Factory(:user)
    activity = Factory(:activity, :item => user, :template => nil)
    assert activity.partial == user.class.name.underscore
  end

  should "be able to edit the activity" do
    user = Factory(:user)
    activity = Factory(:activity, :source => user)
    assert activity.can_edit?(user)
  end
  
  should "not be able to edit the activity" do
    user = Factory(:user)
    activity = Factory(:activity)
    assert !activity.can_edit?(user)
  end
  
  should "filter the activities by template" do
    @template_name = 'test_template'
    user = Factory(:user)
    activity = Factory(:activity, :source => user, :template => @template_name)
    user.activities << activity
    assert user.activities.filter_by_template(@template_name).include?(activity)
  end
  
  should "only find activities created by the source" do
    user = Factory(:user)
    activity = Factory(:activity, :source => user, :template => @template_name)
    user.activities << activity
    
    user2 = Factory(:user)
    activity2 = Factory(:activity, :source => user2, :template => @template_name)
    user2.activities << activity2
    
    assert user.activities.created_by(user).include?(activity)
    assert !user.activities.created_by(user).include?(activity2)
    
  end
  
  context "comments" do
    setup do
      @user = Factory(:user)
      @activity = Factory(:activity)
      @comment = @activity.comments.build(:body => 'a test comment')
      @comment.user = @user
      @comment.save!
    end
    should "have comments" do
      assert_equal 1, @activity.comments.length
    end
    should "have comment cache" do
      @activity.reload
      assert_equal 1, @activity.comment_count
    end
  end
  
end 