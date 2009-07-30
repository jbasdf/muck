class AddCommentCacheToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :comment_count, :integer, :default => 0
  end

  def self.down
    remove_column :entries, :comment_count
  end
end