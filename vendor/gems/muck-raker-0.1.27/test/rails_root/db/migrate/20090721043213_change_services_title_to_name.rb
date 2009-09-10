class ChangeServicesTitleToName < ActiveRecord::Migration
  def self.up
    rename_column :services, :title, :name
  end

  def self.down
    rename_column :services, :name, :title
  end
end
