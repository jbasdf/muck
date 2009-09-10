require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  context 'A user instance' do
    should_have_many :permissions
    should_have_many :roles
    
    should_have_named_scope :by_newest
    should_have_named_scope :active
    should_have_named_scope :inactive
    should_have_named_scope :recent
    
    should_ensure_length_in_range :email, 6..100 #, :short_message => 'does not look like a valid email address.', :long_message => 'does not look like a valid email address.'
    should_allow_values_for :email, 'a@x.com', 'de.veloper@example.com'
    should_not_allow_values_for :email, 'example.com', '@example.com', 'developer@example', 'developer', :message => 'does not look like a valid email address.'

    should_not_allow_values_for :login, 'test guy', 'test.guy', 'testguy!', 'test@guy.com', :message => 'may only contain letters, numbers or a hyphen.'
    should_allow_values_for :login, 'testguy', 'test-guy'
    
    
    should_not_allow_mass_assignment_of :crypted_password, :password_salt, :persistence_token, :single_access_token, :perishable_token, :login_count,
                   :failed_login_count, :last_request_at, :last_login_at, :current_login_at, :current_login_ip, :last_login_ip, 
                   :terms_of_service, :time_zone, :disabled_at, :activated_at, :created_at, :updated_at
  end

  context "search" do
    setup do
      @user = Factory(:user, :first_name => 'john', :last_name => 'smith', :email => 'john.smith@example.com') 
    end
    should "find john" do
      assert User.do_search(:first_name => 'john').include?(@user)
    end
    should "find smith" do
      assert User.do_search(:first_name => 'john').include?(@user)
    end
    should "find john.smith@example.com" do
      assert User.do_search(:email => 'john.smith@example.com').include?(@user)
    end
  end
  
  context "a user" do
    should "have full name" do
      assert_difference 'User.count' do
        user = Factory(:user, :first_name => 'quent', :last_name => 'smith')
        assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
        assert user.full_name == 'quent smith'
      end
    end

    should "show display name if first and last name is blank" do
      @del_user = User.new
      @del_user.destroy
      assert_equal @del_user.display_name,  @del_user.full_name
    end

    should "not display sensitive information when converted to xml" do
      @user = Factory(:user)
      assert @user.to_xml
      assert_xml_tag( @user.to_xml, :tag => "user" )
      assert_xml_tag( @user.to_xml, :tag => "created-at", :parent => { :tag => "user"} )
      assert_xml_tag( @user.to_xml, :tag => "first-name", :parent => { :tag => "user"} )     
      assert_xml_tag( @user.to_xml, :tag => "last-name", :parent => { :tag => "user"} )
      assert_no_xml_tag( @user.to_xml, :tag => "crypted_password" )
    end

    should "return the first_name or display_name" do
      @user = Factory(:user)
      assert_equal @user.short_name, CGI::escapeHTML(@user.first_name) || @user.display_name
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
  end
  
  context "inactive users" do
    setup do
      @user = Factory(:user, :activated_at => nil)
    end
    should "have at least one inactive user" do
      assert User.inactive_count > 0
    end
    should "be able to activate all users" do
      assert User.activate_all
      assert User.inactive_count == 0
    end
  end

  context "find and activate an inactive user" do
    setup do
      @user_inactive = Factory(:user, :activated_at => nil )
      @user_active = Factory(:user )
    end
  end
  
  context "user exists" do
    setup do
      @user = Factory(:user, :login => 'atestguytoo', :email => 'atestguytoo@example.com')
    end
    should "find user with login" do
      assert User.login_exists?('atestguytoo')
    end
    should "find user with email" do
      assert User.email_exists?('atestguytoo@example.com')
    end
  end

  context "user does not exist" do
    setup do
      @user = Factory(:user, :login => 'atestguytoo', :email => 'atestguytoo@example.com')
    end
    should "NOT find user with login" do
      assert_equal false, User.login_exists?('nonexistentuser')
    end
    should "NOT find user with email" do
      assert_equal false, User.email_exists?('nonexistentuser@example.com')
    end
  end
  
  context "check user roles" do
    setup do
      @user = Factory(:user)
    end
    should "be in admin role" do
      @user.add_to_role('administrator')
      @user.reload
      assert @user.admin?
    end
    should "add the user to the specified role" do
      @user.add_to_role('bla')
      @user.reload
      assert @user.has_role?('bla')
    end
    should "find the user in any role" do
      @user.add_to_role('bla')
      @user.add_to_role('foo')
      @user.add_to_role('bar')
      @user.reload
      assert @user.any_role?('bla', 'foo')
      assert @user.any_role?('bar')
      assert !@user.any_role?('alb')
    end
    should "only add the user to the given role once" do
      @user.roles.delete_all
      @user.add_to_role('bla')
      @user.add_to_role('bla')
      @user.reload
      assert_equal 1, @user.roles.count
    end
  end

  context "user can edit" do
    setup do
      @user = Factory(:user)
      @anotheruser = Factory(:user)
    end
    should "be false if user is nil" do
      assert_equal false, @user.can_edit?(nil)
    end
    should "be false if user is not self or an admin" do
      assert_equal false, @user.can_edit?( @anotheruser )
      assert_equal false, @anotheruser.admin?
      assert_equal false, @user.can_edit?( @anotheruser )
    end
    should "be true if user is self" do
      assert @user.can_edit?( @user )
    end
    should "be true if user is an admin" do
      @anotheruser.add_to_role('administrator')
      @anotheruser.reload
      assert @user.can_edit?( @anotheruser )
    end
  end

end
