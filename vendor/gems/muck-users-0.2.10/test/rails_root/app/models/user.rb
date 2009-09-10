class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  acts_as_muck_user

  # these are just for testing
  def creator_id
    self.id
  end

  def user_id
    self.id
  end

  def shared_by_id
    self.id
  end
  
end
