class AddCommentCountToShares < ActiveRecord::Migration
  def self.up
    add_column :shares, :comment_count, :integer, :default => 0
  end

  def self.down
    remove_column :shares, :comment_count
  end
end