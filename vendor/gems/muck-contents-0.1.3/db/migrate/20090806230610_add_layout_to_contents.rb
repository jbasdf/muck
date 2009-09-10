class AddLayoutToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :layout, :string
  end

  def self.down
    remove_column :contents, :layout
  end
end
