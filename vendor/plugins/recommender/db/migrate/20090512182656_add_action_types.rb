class AddActionTypes < ActiveRecord::Migration
  def self.up
	  create_table "action_types", :force => true do |t|
		    t.string "action_type"
		    t.integer "weight"
	  end
  end

  def self.down
	  drop_table "action_types"
  end
end
