require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < ActiveSupport::TestCase

  should_validate_presence_of :rolename
  should_have_many :permissions

  context "Create new role" do
    should "should create a new role" do
      assert_difference 'Role.count' do
        new_role = Role.create(:rolename => "new role")
        new_role.save
      end
    end
  end
  
end