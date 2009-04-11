class MuckBlurbEngine < ActiveRecord::Migration
  def self.up
    create_table :blurbs, :force => true do |t|
      t.integer  :source_id
      t.string   :source_type
      t.string :text
      t.timestamps
    end
    add_index :blurbs, ["source_id", "source_type"]
  end

  def self.down
    drop_table :blurbs
  end
end
