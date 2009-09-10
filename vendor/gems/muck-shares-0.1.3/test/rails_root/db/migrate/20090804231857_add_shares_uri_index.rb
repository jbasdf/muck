class AddSharesUriIndex < ActiveRecord::Migration
  def self.up
    add_index :shares, :uri
  end

  def self.down
    remove_index :shares, :uri
  end
end
