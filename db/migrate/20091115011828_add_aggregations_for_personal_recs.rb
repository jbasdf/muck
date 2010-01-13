class AddAggregationsForPersonalRecs < ActiveRecord::Migration
  def self.up
    add_column :aggregation_feeds, :feed_type, :string
  end

  def self.down
    remove_column :aggregation_feeds, :feed_type
  end
end
