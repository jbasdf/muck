class AddUriKeyToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :uri_key, :string
  end

  def self.down
    remove_column :services, :uri_key
  end
end
