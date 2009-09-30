class RenameNameInAggregation < ActiveRecord::Migration
  def self.up
    rename_column :aggregations, :name, :terms
  end

  def self.down
    rename_column :aggregations, :terms, :name
  end
end
