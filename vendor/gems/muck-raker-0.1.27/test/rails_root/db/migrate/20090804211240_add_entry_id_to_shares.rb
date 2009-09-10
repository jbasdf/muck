class AddEntryIdToShares < ActiveRecord::Migration
  def self.up
    add_column :shares, :entry_id, :integer
  end

  def self.down
    remove_column :shares, :entry_id
  end
end
