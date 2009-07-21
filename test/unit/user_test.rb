# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)
#  email               :string(255)
#  first_name          :string(255)
#  last_name           :string(255)
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  persistence_token   :string(255)
#  single_access_token :string(255)
#  perishable_token    :string(255)
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  last_login_at       :datetime
#  current_login_at    :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  terms_of_service    :boolean(1)      not null
#  time_zone           :string(255)     default("UTC")
#  disabled_at         :datetime
#  activated_at        :datetime
#  created_at          :datetime
#  updated_at          :datetime
#  photo_file_name     :string(255)
#  photo_content_type  :string(255)
#  photo_file_size     :integer(4)
#

require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  context 'A user instance' do
    should_have_many :uploads
  end

  should "let itself view itself" do
    user = Factory(:user)
    assert user.can_view?(user)
  end
  
  context "user activities" do
    setup do
      @user = Factory(:user)
    end
    
    should "add activities after create" do
      assert_difference "Activity.count", 2 do
        user = Factory(:user)
      end
    end
    
    should "add welcome activity" do
      templates = @user.activities.map(&:template)
      assert templates.include?('welcome')
    end
  
    should "add status update activity" do
      templates = @user.activities.map(&:template)
      assert templates.include?('status_update')
    end
  
  end
  
end
