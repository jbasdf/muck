class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string   :login
      t.string   :email
      t.string   :first_name
      t.string   :last_name
      t.string   :crypted_password,          :limit => 40
      t.string   :salt,                      :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :activation_code,           :limit => 40
      t.datetime :activated_at
      t.string   :password_reset_code,       :limit => 40
      t.boolean  :enabled,                   :default => true
      t.boolean  :terms_of_service,          :default => false, :null => false
      t.string   :time_zone,                 :default => "UTC"
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean  :is_active,                 :default => false
      t.string   :identity_url
      t.string   :url_key
    end

    add_index "users", ["login"], :name => "index_users_on_login"
    
  end

  def self.down
    drop_table :users
  end
end  
