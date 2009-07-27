class CreateFeedParents < ActiveRecord::Migration
  def self.up
    create_table :feed_parents, :force => true do |t|
      t.integer :feed_id
      t.integer :ownable_id
      t.string  :ownable_type
      t.timestamps
    end

    add_index :feed_parents, ["feed_id"]
    add_index :feed_parents, ["ownable_id", "ownable_type"]
  end

  def self.down
    drop_table :feed_parents
  end
end
