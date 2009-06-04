class User < ActiveRecord::Base
  
  acts_as_authenticated_user
  
  has_permalink :login, :url_key
  # acts_as_tagger
  # has_attached_file :icon, 
  #                   :styles => { :medium => "300x300>",
  #                                :thumb => "100x100>" }

  #validates_acceptance_of :terms_of_service, :allow_nil => false, :accept => true
  #validates_acceptance_of :terms_of_service, :on => :create

  composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w( time_zone time_zone )

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