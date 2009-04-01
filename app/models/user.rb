class User < ActiveRecord::Base
  
  acts_as_authenticated_user
  acts_as_tagger
  
  has_permalink :login, :url_key

  def short_name
    self.first_name || login
  end
  
  def full_name
    if self.first_name.blank? && self.last_name.blank?
      self.login rescue 'Deleted user'
    else
      ((self.first_name || '') + ' ' + (self.last_name || '')).strip
    end
  end

  def to_param
    self.url_key
  end

  def display_name
    h(self.login)
  end
  
end
