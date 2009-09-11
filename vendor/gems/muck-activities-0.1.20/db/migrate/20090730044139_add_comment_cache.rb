class AddCommentCache < ActiveRecord::Migration
  def self.up
    add_column :activities, :comment_count, :integer, :default => 0
  end

  def self.down
    remove_column :activities, :comment_count
  end
end
