class MakeInvitesPolymorphic < ActiveRecord::Migration
  
  def self.up
    drop_table :user_invites
    rename_table :invites, :invitees
    create_table :invites, :force => true do |t|
      t.integer  :user_id
      t.integer  :invitee_id, :null => false
      t.integer  :inviter_id, :null => false
      t.string   :inviter_type
      t.timestamps
    end
    add_index :invites, ["inviter_id", "inviter_type"]
  end

  def self.down
    drop_table :invites
    rename_table :invitees, :invites
    create_table :user_invites, :force => true do |t|
      t.integer  :user_id, :null => false
      t.integer  :invite_id, :null => false
      t.timestamp :created_at, :null => false
    end
    add_index :user_invites, ["user_id"]
  end
  
end
