require File.dirname(__FILE__) + '/../test_helper'

class PermissionTest < ActiveSupport::TestCase

  should_belong_to :user
  should_belong_to :role
  
  context "Create new permission" do
    should "should create a new permission" do
      assert_difference 'Permission.count' do
        user = Factory(:user)
        role = Factory(:role)
        permission = Permission.create(:user => user, :role => role)
        permission.save
      end
    end
  end
  
end
