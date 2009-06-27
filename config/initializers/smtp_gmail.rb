require "smtp_tls" # Remove this line if using Ruby 1.8.7

unless Rails.env.test? # we don't want tests attempting to send out email
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true,
    :user_name => GlobalConfig.email_user_name,
    :password => GlobalConfig.email_password,
    :domain => GlobalConfig.base_domain
  }
end

ActionMailer::Base.default_url_options[:host] = GlobalConfig.application_url

# test:
# UserMailer.deliver_welcome_notification(User.find(2))
