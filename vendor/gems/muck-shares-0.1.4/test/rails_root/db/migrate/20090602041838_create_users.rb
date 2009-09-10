class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table :users, :force => true do |t|
      t.string   :login
      t.string   :email
      t.string   :first_name
      t.string   :last_name
      t.string   :crypted_password
      t.string   :password_salt
      t.string   :persistence_token
      t.string   :single_access_token
      t.string   :perishable_token
      t.integer  :login_count,         :null => false, :default => 0
      t.integer  :failed_login_count,  :null => false, :default => 0
      t.datetime :last_request_at                                   
      t.datetime :last_login_at 
      t.datetime :current_login_at                                  
      t.string   :current_login_ip                                  
      t.string   :last_login_ip
      t.boolean  :terms_of_service,   :default => false, :null => false
      t.string   :time_zone,          :default => "UTC"
      t.datetime :disabled_at
      t.datetime :activated_at
      t.timestamps
    end

    add_index :users, :login
    add_index :users, :email
    add_index :users, :persistence_token
    add_index :users, :perishable_token
    add_index :users, :single_access_token
    add_index :users, :last_request_at
  end

  def self.down
    drop_table :users
  end
end