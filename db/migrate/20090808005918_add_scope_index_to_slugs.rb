class AddScopeIndexToSlugs < ActiveRecord::Migration
  def self.up
    add_index :slugs, :scope
  end

  def self.down
    remove_index :slugs, :scope
  end
end
