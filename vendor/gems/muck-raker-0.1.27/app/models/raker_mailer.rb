class RakerMailer < ActionMailer::Base
  unloadable
  
  layout 'email_default'
  default_url_options[:host] = GlobalConfig.application_url
 
  def notification_feed_added(feed)
    recipients  GlobalConfig.admin_email
    from        "#{GlobalConfig.from_email_name} <#{GlobalConfig.from_email}>"
    sent_on     Time.now
    subject     I18n.t('muck.raker.new_global_feed', :application_name => GlobalConfig.application_name)
    body        :feed => feed,
                :application_name => GlobalConfig.application_name
  end

end
