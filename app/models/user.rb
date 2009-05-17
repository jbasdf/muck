# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)
#  email               :string(255)
#  first_name          :string(255)
#  last_name           :string(255)
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  persistence_token   :string(255)
#  single_access_token :string(255)
#  perishable_token    :string(255)
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  last_login_at       :datetime
#  current_login_at    :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  terms_of_service    :boolean(1)      not null
#  time_zone           :string(255)     default("UTC")
#  disabled_at         :datetime
#  activated_at        :datetime
#  created_at          :datetime
#  updated_at          :datetime
#  photo_file_name     :string(255)
#  photo_content_type  :string(255)
#  photo_file_size     :integer(4)
#

class User < ActiveRecord::Base
  
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end
  acts_as_muck_user
  acts_as_tagger
  has_activities
  has_friendly_id :login
  
  # Files - documents, photos, etc
  has_many :uploads, :as => :uploadable, :order => 'created_at desc', :dependent => :destroy
  
  def after_create
    content = I18n.t('muck.activities.joined_status', :name => self.full_name, :application_name => GlobalConfig.application_name)
    add_activity(self, self, self, 'status_update', '', content)
  end
  
  # This is only a place holder.  Override this method to feed activities to the appropriate places
  def feed_to
    [self]
  end
  
end
