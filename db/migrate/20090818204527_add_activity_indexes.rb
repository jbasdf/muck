class AddActivityIndexes < ActiveRecord::Migration
  def self.up
    add_index :activities, ["source_id", "source_type"]
  end

  def self.down
    remove_index :activities, ["source_id", "source_type"]
  end
end
