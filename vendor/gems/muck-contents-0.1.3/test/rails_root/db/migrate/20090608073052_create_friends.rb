class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends, :force => true do |t|
      t.integer  "inviter_id"
      t.integer  "invited_id"
      t.integer  "status", :default => 0
      t.timestamps
    end
    add_index :friends, ["inviter_id", "invited_id"]
    add_index :friends, ["invited_id", "inviter_id"]
  end

  def self.down
    drop_table :friends
  end
end
