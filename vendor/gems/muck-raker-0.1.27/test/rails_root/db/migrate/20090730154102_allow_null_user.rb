class AllowNullUser < ActiveRecord::Migration
  def self.up
    change_column :comments, :user_id, :integer, :null => true, :default => nil
  end

  def self.down
    change_column :comments, :user_id, :integer, :null => false, :default => 0
  end
end
