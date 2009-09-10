class CreateIdentityFeeds < ActiveRecord::Migration
  def self.up
    create_table :identity_feeds, :force => true do |t|
      t.integer  "feed_id",   :null => false
      t.integer  "ownable_id",  :null => false
      t.string  "ownable_type", :null => false
    end
    add_index :identity_feeds, ["ownable_id", "ownable_type"]
  end

  def self.down
    drop_table :identity_feeds
  end
end