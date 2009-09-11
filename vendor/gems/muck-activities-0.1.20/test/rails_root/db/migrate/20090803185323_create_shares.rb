class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares, :force => true do |t|
      t.string  :uri,               :limit => 2083, :default => "", :null => false
      t.string  :title
      t.text    :message
      t.integer :shared_by_id,                                      :null => false
      t.timestamps
    end
    add_index :shares, :shared_by_id
  end

  def self.down
    drop_table :shares
  end
end
