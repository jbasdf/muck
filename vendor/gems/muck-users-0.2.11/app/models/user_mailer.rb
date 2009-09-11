class UserMailer < ActionMailer::Base
  unloadable
  
  layout 'email_default'
  default_url_options[:host] = GlobalConfig.application_url
  
  def activation_confirmation(user)
    setup_email(user)
    subject   I18n.t('muck.users.activation_complete')
    body      :user => user
  end
  
  def activation_instructions(user)
    setup_email(user)
    subject   I18n.t('muck.users.activation_instructions')
    body      :user => user,
              :account_activation_url => activate_url(user.perishable_token)
  end

  def password_not_active_instructions(user)
    setup_email(user)
    subject   I18n.t('muck.users.account_not_activated', :application_name => GlobalConfig.application_name)
    body      :user => user
  end

  def password_reset_instructions(user)
    setup_email(user)
    subject   I18n.t('muck.users.password_reset_email_subject', :application_name => GlobalConfig.application_name)
    body      :user => user
  end

  def welcome_notification(user)
    setup_email(user)
    subject   I18n.t('muck.users.welcome_email_subject', :application_name => GlobalConfig.application_name)
    body      :user => user,
              :application_name => GlobalConfig.application_name
  end

  def username_request(user)
    setup_email(user)
    subject   I18n.t('muck.users.request_username_subject', :application_name => GlobalConfig.application_name)
    body      :user => user,
              :application_name => GlobalConfig.application_name
  end
  
  protected
    def setup_email(user)
      recipients    user.email
      from          "#{GlobalConfig.from_email_name} <#{GlobalConfig.from_email}>"
      sent_on       Time.now
      content_type "text/html" # There is a bug in Rails that prevents multipart emails from working inside an engine.  See: https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2263-rails-232-breaks-implicit-multipart-actionmailer-tests#ticket-2263-22
    end

end
