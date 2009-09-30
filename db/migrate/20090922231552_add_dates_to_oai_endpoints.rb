class AddDatesToOaiEndpoints < ActiveRecord::Migration
  def self.up
    add_column :oai_endpoints, :created_at, :datetime
    add_column :oai_endpoints, :updated_at, :datetime
  end

  def self.down
    remove_column :oai_endpoints, :created_at
    remove_column :oai_endpoints, :updated_at
  end
end
