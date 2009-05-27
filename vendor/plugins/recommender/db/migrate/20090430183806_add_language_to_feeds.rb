class AddLanguageToFeeds < ActiveRecord::Migration
  def self.up
  add_column :feeds, :language, :string
  end

  def self.down
  remove_column :feeds, :language
  end
end
