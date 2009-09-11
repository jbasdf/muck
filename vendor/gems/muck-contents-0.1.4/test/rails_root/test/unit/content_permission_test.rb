require File.dirname(__FILE__) + '/../test_helper'

# Used to test muck_content_permission
class ContentPermissionTest < ActiveSupport::TestCase

  context "A content permission instance" do
    setup do
      @content_permission = Factory(:content_permission)
    end
    
    should_belong_to :content
    should_belong_to :user
    
    context "Get permission by user" do
      setup do
        @user_with_permission = Factory(:user)
        @user_no_permission = Factory(:user)
        Factory(:content_permission, :user => @user_with_permission)
      end
      should "find user with permissions" do
        ContentPermission.by_user(@user_with_permission).map(&:user_id).include?(@user_with_permission.id)
      end
      should "not find user without permissions" do
        assert ContentPermission.by_user(@user_no_permission).blank?
      end
    end
    
  end
  
end