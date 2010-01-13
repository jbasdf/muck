class AddFieldsToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :about, :text
    add_column :profiles, :first_name, :string
    add_column :profiles, :last_name, :string
    add_column :profiles, :city, :string
    add_column :profiles, :state_id, :integer
    add_column :profiles, :country_id, :integer
    add_column :profiles, :language_id, :integer
  end

  def self.down
    remove_column :profiles, :about
    remove_column :profiles, :first_name
    remove_column :profiles, :last_name
    remove_column :profiles, :city
    remove_column :profiles, :state_id
    remove_column :profiles, :country_id
    remove_column :profiles, :language_id
  end
end