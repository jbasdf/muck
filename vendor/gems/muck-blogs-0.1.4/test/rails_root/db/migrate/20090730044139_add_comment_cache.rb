class AddBlogCache < ActiveRecord::Migration
  def self.up
    add_column :activities, :blog_count, :integer, :default => 0
  end

  def self.down
    remove_column :activities, :blog_count
  end
end
