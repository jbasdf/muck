class AddFeedCountToAggregation < ActiveRecord::Migration
  def self.up
    add_column :aggregations, :feed_count, :integer, :default => 0
  end

  def self.down
    remove_column :aggregations, :feed_count
  end
end