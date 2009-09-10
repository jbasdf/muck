class AddAttachableToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :attachable_id, :integer
    add_column :activities, :attachable_type, :string
    add_index :activities, ["attachable_id", "attachable_type"]
  end

  def self.down
    remove_column :activities, :attachable_id
    remove_column :activities, :attachable_type
    remove_index :activities, ["attachable_id", "attachable_type"]
  end
end