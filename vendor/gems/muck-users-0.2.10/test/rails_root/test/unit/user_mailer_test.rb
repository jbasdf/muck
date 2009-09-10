require File.dirname(__FILE__) + '/../test_helper'
require 'user_mailer'

class UserMailerTest < ActiveSupport::TestCase

  context "deliver emails" do

    def setup
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      @expected = TMail::Mail.new
      @expected.set_content_type "text", "plain", { "charset" => 'utf-8' }
    end

    should "send activation confirmation email" do
      user = Factory(:user)
      response = UserMailer.deliver_activation_confirmation(user)
      assert !ActionMailer::Base.deliveries.empty?, "No email was sent"
      assert_match "#{user.login}", response.body, "User login was not found in the email"
      email = ActionMailer::Base.deliveries.last
      assert_equal email.to, [user.email]
      assert_equal email.from, [GlobalConfig.from_email]
    end

    should "send activation instructions email" do
      user = Factory(:user)
      response = UserMailer.deliver_activation_instructions(user)
      assert !ActionMailer::Base.deliveries.empty?, "No email was sent"
      assert_match "#{user.login}", response.body, "User login was not found in the email"
      email = ActionMailer::Base.deliveries.last
      assert_equal email.to, [user.email]
      assert_equal email.from, [GlobalConfig.from_email]
    end

    should "send password reset account not active instructions email" do
      user = Factory(:user)
      response = UserMailer.deliver_password_not_active_instructions(user)
      assert !ActionMailer::Base.deliveries.empty?, "No email was sent"
      email = ActionMailer::Base.deliveries.last
      assert_equal email.to, [user.email]
      assert_equal email.from, [GlobalConfig.from_email]
    end
    
    should "send password reset instructions email" do
      user = Factory(:user)
      response = UserMailer.deliver_password_reset_instructions(user)
      assert !ActionMailer::Base.deliveries.empty?, "No email was sent"
      email = ActionMailer::Base.deliveries.last
      assert_equal email.to, [user.email]
      assert_equal email.from, [GlobalConfig.from_email]
    end
    
    should "send username request email" do
      user = Factory(:user)
      response = UserMailer.deliver_username_request(user)
      assert !ActionMailer::Base.deliveries.empty?, "No email was sent"
      email = ActionMailer::Base.deliveries.last
      assert_equal email.to, [user.email]
      assert_equal email.from, [GlobalConfig.from_email]
    end
    
    should "send welcome email" do
      user = Factory(:user)
      response = UserMailer.deliver_welcome_notification(user)
      assert !ActionMailer::Base.deliveries.empty?, "No email was sent"
      email = ActionMailer::Base.deliveries.last
      assert_equal email.to, [user.email]
      assert_equal email.from, [GlobalConfig.from_email]
    end
    
  end  
end
