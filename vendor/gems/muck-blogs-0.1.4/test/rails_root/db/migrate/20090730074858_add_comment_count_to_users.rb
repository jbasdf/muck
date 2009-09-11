class AddBlogCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :blog_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :blog_count
  end
end
