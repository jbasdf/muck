require File.dirname(__FILE__) + '/../test_helper'
require 'comment_mailer'

class CommentMailerTest < ActiveSupport::TestCase

  context "deliver emails" do

    def setup
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      @expected = TMail::Mail.new
      @expected.set_content_type "text", "plain", { "charset" => 'utf-8' }
    end
    
    should "send new comment email" do
      comment = Factory(:comment)
      response = CommentMailer.deliver_new_comment(comment)
      assert !ActionMailer::Base.deliveries.empty?, "No email was sent"
      email = ActionMailer::Base.deliveries.last
      assert_equal [comment.user.email], email.to
      assert_equal [GlobalConfig.from_email], email.from
    end
    
  end  
end
