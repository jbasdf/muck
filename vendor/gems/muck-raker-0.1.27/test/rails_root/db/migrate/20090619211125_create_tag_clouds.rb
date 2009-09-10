class CreateTagClouds < ActiveRecord::Migration
  def self.up
    
    drop_table "cloud_caches"
    
    create_table "tag_clouds", :force => true do |t| 
      t.integer  "language_id"
      t.string   "filter"
      t.string   "tag_list", :limit => 5000
    end
    
    add_index "tag_clouds", ["language_id", "filter"], {:unique => true}

  end

  def self.down
    drop_table "tag_clouds"
  end
end
