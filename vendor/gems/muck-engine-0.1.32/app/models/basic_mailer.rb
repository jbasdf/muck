class BasicMailer < ActionMailer::Base
  
  def mail(options)
    @recipients = options[:recipients] || GlobalConfig.support_email
    @from = options[:from] || GlobalConfig.email_from
    @cc = options[:cc] || ""
    @bcc = options[:bcc] || ""
    @subject = options[:subject] || ""
    @body = options[:body] || {}
    @headers = options[:headers] || {}
    @charset = options[:charset] || "utf-8"
    @content_type = options[:content_type] || "text/plain"
  end
  
end