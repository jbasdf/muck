class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments, :force => true do |t|
      t.integer   :commentable_id, :default => 0
      t.string    :commentable_type, :limit => 15, :default => ""
      t.text      :body
      t.integer   :user_id, :default => 0, :null => false
      t.integer   :parent_id
      t.integer   :lft
      t.integer   :rgt
      t.integer   :is_denied,        :default => 0,     :null => false
      t.boolean   :is_reviewed,      :default => false
      t.timestamps
    end

    add_index :comments, ["user_id"]
    add_index :comments, ["commentable_id", "commentable_type"]
    
  end

  def self.down
    drop_table :comments
  end
end
