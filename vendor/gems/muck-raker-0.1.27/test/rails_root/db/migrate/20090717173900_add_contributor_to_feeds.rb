class AddContributorToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :contributor_id, :integer
  end

  def self.down
    remove_column :feeds, :contributor_id
  end
end
