class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages, :force => true do |t|
      t.string :name
      t.string :english_name
      t.string :locale
      t.boolean :supported, :default => true
      t.boolean :is_default, :default => false
    end
    add_index :languages, :name
    add_index :languages, :locale
  end

  def self.down
    drop_table :languages
  end
  
end
