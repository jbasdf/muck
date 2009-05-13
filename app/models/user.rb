class User < ActiveRecord::Base
  
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  acts_as_muck_user
  acts_as_tagger
  has_activities
  has_friendly_id :login
  
  def after_create
    content = I18n.t('muck.activities.joined_status', :name => self.full_name, :application_name => GlobalConfig.application_name)
    add_activity(self, self, self, 'status_update', '', content)
  end
  
  # This is only a place holder.  Override this method to feed activities to the appropriate places
  def feed_to
    [self]
  end
  
end
