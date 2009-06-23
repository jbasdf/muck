class AddContentTypeToEntries < ActiveRecord::Migration
  def self.up
    add_column :feeds, :default_grain_size, :string, :default => "unknown"
    execute "UPDATE feeds SET default_grain_size = 'course' WHERE ocw = true" 
    remove_column :feeds, :ocw

    add_column :entries, :grain_size, :string, :default => "unknown"
    add_index "entries", ["grain_size"]
  end

  def self.down
    remove_column :feeds, :default_grain_size
    remove_column :entries, :grain_size
    add_column :fields, :ocw, :boolean, :default => false
  end
end
