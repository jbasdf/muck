class AddMuckActivities < ActiveRecord::Migration
  
  def self.up
  
    create_table :activities, :force => true do |t|
      t.integer  :item_id
      t.string   :item_type
      t.string   :template
      t.integer  :source_id
      t.string   :source_type
      t.text     :content
      t.string   :title
      t.string   :activity_type
      t.timestamps
    end

    add_index :activities, ["item_id", "item_type"]

    create_table :activity_feeds, :force => true do |t|
      t.integer :activity_id
      t.integer :ownable_id
      t.string  :ownable_type
    end

    add_index :activity_feeds, ["activity_id"]
    add_index :activity_feeds, ["ownable_id", "ownable_type"]
    
  end

  def self.down
    drop_table :activities
    drop_table :activity_feeds
  end
  
end