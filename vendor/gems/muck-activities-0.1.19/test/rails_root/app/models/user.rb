class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  acts_as_muck_user
  has_muck_profile
  has_activities
  acts_as_muck_sharer
  
  def feed_to
    [self]
  end
  
end