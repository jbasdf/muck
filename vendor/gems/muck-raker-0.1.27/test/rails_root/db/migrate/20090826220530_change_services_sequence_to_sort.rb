class ChangeServicesSequenceToSort < ActiveRecord::Migration
  def self.up
    rename_column :services, 'sequence', 'sort'
  end

  def self.down
    rename_column :services, 'sort', 'sequence'
  end
end
