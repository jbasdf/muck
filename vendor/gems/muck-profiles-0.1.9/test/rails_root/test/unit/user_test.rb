require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  context 'A user instance with has_muck_profile' do
    setup do
      @user = Factory(:user)
    end
    should_accept_nested_attributes_for :profile
    should_have_one :profile
    
    should "have a profile after creation" do
      assert @user.profile
    end

    should "have a photo method delegated to the profile" do
      assert @user.photo
    end
  end

end
