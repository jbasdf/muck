class CommentMailer < ActionMailer::Base
  unloadable
  layout 'email_default'
  default_url_options[:host] = GlobalConfig.application_url
  
  def new_comment(comment)
    if comment.user
      display_name = comment.user.display_name
    else
      display_name = I18n.t('muck.comment.anonymous')
    end
    recipients    emails_for_comment(comment)
    from          "#{GlobalConfig.from_email_name} <#{GlobalConfig.from_email}>"
    sent_on       Time.now
    content_type  "text/html" # There is a bug in Rails that prevents multipart emails from working inside an engine.  See: https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2263-rails-232-breaks-implicit-multipart-actionmailer-tests#ticket-2263-22
    subject       I18n.t('muck.comments.new_comment_email_subject', :name => display_name, :application_name => GlobalConfig.application_name)
    body          :comment => comment, :display_name => display_name
  end
  
  protected
    def emails_for_comment(comment)
      emails = []
      comment.root.self_and_descendants.each do |c|
        emails << c.user.email unless emails.include?(c.user.email) if c.user
      end
      emails
    end
    
end