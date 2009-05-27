class AddAttentions < ActiveRecord::Migration
  def self.up
	  create_table "attentions", :force => true do |t|
		  t.integer "attentionable_id"
		  t.string "attentionable_type"
		  t.integer "entry_id"
		  t.string "action_type"
		  t.float "weight"
	  end
  end

  def self.down
	  drop_table "attentions"
  end
end
