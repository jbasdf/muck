class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites, :force => true do |t|
      t.string  "email", :null => false
    end
    add_index :invites, ["email"]

    create_table :user_invites, :force => true do |t|
      t.integer  "user_id", :null => false
      t.integer  "invite_id", :null => false
      t.timestamp "created_at", :null => false
    end
    add_index :user_invites, ["user_id"]
  end

  def self.down
    drop_table :user_invites
    drop_table :invites
  end
end
