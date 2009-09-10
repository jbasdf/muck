class AddIdentityFieldsToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :use_for, :string
    add_column :services, :service_category_id, :integer
    add_column :services, :active, :boolean, :default => true
  end

  def self.down
    remove_column :services, :use_for
    remove_column :services, :service_category_id
    remove_column :services, :active
  end
end
