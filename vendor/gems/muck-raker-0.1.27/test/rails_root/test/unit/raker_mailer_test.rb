require File.dirname(__FILE__) + '/../test_helper'
require 'raker_mailer'

class RakerMailerTest < ActiveSupport::TestCase

  context "deliver emails" do

    def setup
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      @expected = TMail::Mail.new
      @expected.set_content_type "text", "plain", { "charset" => 'utf-8' }
    end

    should "send notification feed added email" do
      feed = Factory(:feed)
      response = RakerMailer.deliver_notification_feed_added(feed)
      assert !ActionMailer::Base.deliveries.empty?, "No email was sent"
      email = ActionMailer::Base.deliveries.last
      assert_equal email.to, [GlobalConfig.admin_email]
      assert_equal email.from, [GlobalConfig.from_email]
    end

  end
end
