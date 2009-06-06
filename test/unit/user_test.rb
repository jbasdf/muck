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
              
    should_require_unique_attributes :login, :email
    should_require_attributes :login, :email, :first_name, :last_name 

    should_ensure_length_in_range :password, (4..40)
    should_ensure_length_in_range :login, (3..40)

    should_have_many :permissions
    should_have_many :roles, :through => :permissions

    should_protect_attributes :crypted_password, :salt, :remember_token, :remember_token_expires_at, :activation_code, :activated_at,
                              :password_reset_code, :enabled, :can_send_messages, :is_active, :created_at, :updated_at, :plone_password,
                              :posts_count

    should_ensure_length_in_range :email, 6..100 #, :short_message => 'does not look like a valid email address.', :long_message => 'does not look like a valid email address.'
    should_allow_values_for :email, 'a@x.com', 'de.veloper@example.com'
    should_not_allow_values_for :email, 'example.com', '@example.com', 'developer@example', 'developer', :message => 'does not look like a valid email address.'

    should_not_allow_values_for :login, 'test guy', 'test.guy', 'testguy!', 'test@guy.com', :message => 'may only contain letters, numbers or a hyphen.'
    should_allow_values_for :login, 'testguy', 'test-guy'
    
  end

  should "have full name" do
    assert_difference 'User.count' do
      user = Factory(:user, :first_name => 'quent', :last_name => 'smith')
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
      assert user.full_name == 'quent smith'
    end
  end
  
  should "have display name" do
    assert_difference 'User.count' do
      user = Factory(:user, :login => 'quentguy')
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
      assert user.display_name == 'quentguy'
    end
  end
  
  should "Create a new user and lowercase the login" do
    assert_difference 'User.count' do
      user = Factory(:user, :login => 'TESTGUY')
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
      assert user.login == 'testguy'
    end
  end

  should "Not allow login with dot" do
    user = Factory.build(:user, :login => 'test.guy')
    assert !user.valid?
  end

  should "Not allow login with dots" do
    user = Factory.build(:user, :login => 'test.guy.guy')
    assert !user.valid?
  end

  should "Allow login with dash" do
    user = Factory.build(:user, :login => 'test-guy')
    assert user.valid?
  end

  should "Not allow login with '@'" do
    user = Factory.build(:user, :login => 'testguy@example.com')
    assert !user.valid?
  end         

  should "Not allow login with '!'" do
    user = Factory.build(:user, :login => 'testguy!')
    assert !user.valid?
  end

  should "let itself view" do
    user = Factory(:user)
    assert user.can_view?(user)
  end

  should "initialize activation code upon creation" do
    user = Factory(:user)
    assert_not_nil user.activation_code
  end

  should "require login" do
    assert_no_difference 'User.count' do
      u = Factory.build(:user, :login => nil)
      assert !u.valid?
      assert u.errors.on(:login)
    end
  end

  should "require password" do
    assert_no_difference 'User.count' do
      u = Factory.build(:user, :password => nil)
      assert !u.valid?
      assert u.errors.on(:password)
    end
  end

  should "require password confirmation" do
    assert_no_difference 'User.count' do
      u = Factory.build(:user, :password_confirmation => nil)
      assert !u.valid?
      assert u.errors.on(:password_confirmation)
    end
  end

  should "require require email" do
    assert_no_difference 'User.count' do
      u = Factory.build(:user, :email => nil)
      assert !u.valid?
      assert u.errors.on(:email)
    end
  end

  should "be able to reset their password" do
    assert_not_equal false, users(:quentin).update_attributes(:email => "hiapal@hotmail.com", :password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  end

  def test_associations
    _test_associations
  end
  
end
