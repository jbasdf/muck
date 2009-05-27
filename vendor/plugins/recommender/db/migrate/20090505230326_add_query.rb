class AddQuery < ActiveRecord::Migration
  def self.up
    create_table "queries", :force => true do |t|
      t.text "name"
      t.integer "frequency"
    end
  
  end

  def self.down
    drop_table "queries"
  end
end
