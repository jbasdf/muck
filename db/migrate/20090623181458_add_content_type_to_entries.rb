class AddContentTypeToEntries < ActiveRecord::Migration
  def self.up
    add_column :feeds, :default_content_type, :string, :default => "unknown"
    execute "UPDATE feeds SET default_content_type = 'course' WHERE ocw = true" 
    remove_column :feeds, :ocw

    add_column :entries, :content_type, :string, :default => "unknown"
    add_index "entries", ["content_type"]
  end

  def self.down
    remove_column :feeds, :default_content_type
    remove_column :entries, :content_type
    add_column :fields, :ocw, :boolean, :default => false
  end
end
