class AllowNullUser < ActiveRecord::Migration
  def self.up
    change_column :blogs, :user_id, :integer, :null => true, :default => nil
  end

  def self.down
    change_column :blogs, :user_id, :integer, :null => false, :default => 0
  end
end
