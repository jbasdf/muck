class AggregationsToPolymorphic < ActiveRecord::Migration
  def self.up
    remove_column :aggregations, :user_id
    add_column :aggregations, :ownable_id, :integer
    add_column :aggregations, :ownable_type, :string
    add_index :aggregations, [:ownable_id, :ownable_type]
  end

  def self.down
    add_column :aggregations, :user_id, :integer
    remove_column :aggregations, :ownable_id
    remove_column :aggregations, :ownable_type
    remove_index :aggregations, [:ownable_id, :ownable_type]
  end
end
