class RemoveServicesNotNullFromFeeds < ActiveRecord::Migration
  def self.up
    change_column :feeds, :service_id, :integer, :null => true
  end

  def self.down
    change_column :feeds, :service_id, :integer, :null => false
  end
end