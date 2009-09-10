class FriendMailer < ActionMailer::Base
  unloadable
  layout 'email_default'
  default_url_options[:host] = GlobalConfig.application_url
  
  def follow(inviter, invited)
    setup_email(invited.email)
    subject       I18n.t('muck.friends.following_you', :name => inviter.login, :application_name => GlobalConfig.application_name)
    body          :inviter => inviter, :invited => invited
  end

  def friend_request(inviter, invited)
    setup_email(invited.email)
    subject       I18n.t('muck.friends.friend_request', :name => inviter.login, :application_name => GlobalConfig.application_name)
    body          :inviter => inviter, :invited => invited
  end
  
  protected
  def setup_email(email)
    recipients  email
    from        "#{GlobalConfig.from_email_name} <#{GlobalConfig.from_email}>"
    sent_on     Time.now
    content_type "text/html" # There is a bug in Rails that prevents multipart emails from working inside an engine.  See: https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2263-rails-232-breaks-implicit-multipart-actionmailer-tests#ticket-2263-22
  end
  
end