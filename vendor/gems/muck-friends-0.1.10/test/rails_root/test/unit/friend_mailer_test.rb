require File.dirname(__FILE__) + '/../test_helper'
require 'friend_mailer'

class FriendMailerTest < ActiveSupport::TestCase

  context "deliver emails" do

    def setup
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      @expected = TMail::Mail.new
      @expected.set_content_type "text", "plain", { "charset" => 'utf-8' }
    end
    
    should "send follow email" do
      inviter = Factory(:user)
      invited = Factory(:user)
      response = FriendMailer.deliver_follow(inviter, invited)
      assert !ActionMailer::Base.deliveries.empty?, "No email was sent"
      email = ActionMailer::Base.deliveries.last
      assert_equal [invited.email], email.to
      assert_equal [GlobalConfig.from_email], email.from
    end
    
    should "send friend_request email" do
      inviter = Factory(:user)
      invited = Factory(:user)
      response = FriendMailer.deliver_friend_request(inviter, invited)
      assert !ActionMailer::Base.deliveries.empty?, "No email was sent"
      email = ActionMailer::Base.deliveries.last
      assert_equal [invited.email], email.to
      assert_equal [GlobalConfig.from_email], email.from
    end
    
  end  
end
