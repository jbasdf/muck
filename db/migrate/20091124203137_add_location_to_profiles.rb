class AddLocationToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :location, :string
    add_column :profiles, :lat, :decimal, :precision => 15, :scale => 10
    add_column :profiles, :lng, :decimal, :precision => 15, :scale => 10
    add_index  :profiles, [:lat, :lng]
  end

  def self.down
    remove_index  :profiles, [:lat, :lng]
    remove_column :profiles, :location
    remove_column :profiles, :lat
    remove_column :profiles, :lng
  end
end
