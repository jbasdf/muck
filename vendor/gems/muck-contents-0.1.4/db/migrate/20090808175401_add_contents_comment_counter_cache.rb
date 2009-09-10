class AddContentsCommentCounterCache < ActiveRecord::Migration
  def self.up
    add_column :contents, :comment_count, :integer, :default => 0
  end

  def self.down
    remove_column :contents, :comment_count
  end
end
