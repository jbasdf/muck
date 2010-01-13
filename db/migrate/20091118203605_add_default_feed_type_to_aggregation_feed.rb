class AddDefaultFeedTypeToAggregationFeed < ActiveRecord::Migration
  def self.up
    change_column :aggregation_feeds, :feed_type, :string, :default => 'Feed'
  end

  def self.down
    change_column :aggregation_feeds, :feed_type, :string, :default => nil
  end
  
end