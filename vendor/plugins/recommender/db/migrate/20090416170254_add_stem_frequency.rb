class AddStemFrequency < ActiveRecord::Migration
  def self.up
  add_column :tags, :stem_frequency, :integer
  end

  def self.down
   remove_column :tags, :stem_frequency
  end
end
