require File.dirname(__FILE__) + '/../test_helper'
require 'basic_mailer'

class BasicMailerTest < ActiveSupport::TestCase

  context "deliver emails" do

    def setup
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      @expected = TMail::Mail.new
      @expected.set_content_type "text", "plain", { "charset" => 'utf-8' }
    end

    should "send email" do
      body = 'test body'
      to = 'to@example.com'
      from = 'from@example.com'
      options = {:recipients => to, :from => from, :subject => 'test message', :body => body}
      response = BasicMailer.deliver_mail(options)
      assert !ActionMailer::Base.deliveries.empty?, "No email was sent"
      assert_match body, response.body, "#{body} was not found in the email"
      email = ActionMailer::Base.deliveries.last
      assert_equal [to], email.to
      assert_equal [from], email.from
    end
  end 
  
end