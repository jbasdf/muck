class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs, :force => true do |t|
      t.integer   :blogable_id, :default => 0
      t.string    :blogable_type, :default => ""
      t.string    :title
      t.timestamps
    end

    add_index :blogs, ["blogable_id", "blogable_type"]
  end

  def self.down
    drop_table :blogs
  end
end
