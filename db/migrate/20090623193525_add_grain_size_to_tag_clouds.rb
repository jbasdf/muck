class AddGrainSizeToTagClouds < ActiveRecord::Migration
  def self.up
    add_column :tag_clouds, :grain_size, :string, :default => "all"
    remove_index "tag_clouds", ["language_id", "filter"]
    add_index "tag_clouds", ["grain_size", "language_id", "filter"], {:unique => true}
  end

  def self.down
    remove_column :tag_clouds, :grain_size
    add_index "entries", ["grain_size"]
  end
end
