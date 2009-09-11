class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs, :force => true do |t|
      t.integer   :blogable_id, :default => 0
      t.string    :blogable_type, :limit => 15, :default => ""
      t.text      :body
      t.integer   :user_id, :default => 0, :null => false
      t.integer   :parent_id
      t.integer   :lft
      t.integer   :rgt
      t.integer   :is_denied,        :default => 0,     :null => false
      t.boolean   :is_reviewed,      :default => false
      t.timestamps
    end

    add_index :blogs, ["user_id"]
    add_index :blogs, ["blogable_id", "blogable_type"]
    
  end

  def self.down
    drop_table :blogs
  end
end
