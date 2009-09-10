class AddCommentCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :comment_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :comment_count
  end
end
