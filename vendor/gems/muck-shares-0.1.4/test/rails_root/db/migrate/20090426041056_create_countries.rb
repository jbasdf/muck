class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries, :force => true do |t|
      t.string "name",         :limit => 128, :default => "", :null => false
      t.string "abbreviation", :limit => 3,   :default => "", :null => false
      t.integer "sort",                       :default => 1000, :null => false
    end
    add_index :countries, :name
    add_index :countries, :abbreviation
  end

  def self.down
    drop_table :countries
  end
end
