class AddFieldsToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :stem, :string
    add_column :tags, :frequency, :integer
    add_column :tags, :root, :boolean
    
    add_index "tags", ["stem"], :name => "index_tags_on_stem"
    add_index "tags", ["frequency"], :name => "index_tags_on_frequency"
    add_index "tags", ["root"], :name => "index_tags_on_root"
  end

  def self.down
    remove_column :tags, :stem
    remove_column :tags, :frequency
    remove_column :tags, :root
  end
end
