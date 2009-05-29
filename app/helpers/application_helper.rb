# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  include TagsHelper
  
  def secure_mail_to(email)
    mail_to email, nil, :encode => 'javascript'
  end
  
end
