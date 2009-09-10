class User < ActiveRecord::Base
  unloadable
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  acts_as_muck_user
  acts_as_muck_sharer
  has_activities
  
  def feed_to
    self
  end
  
end