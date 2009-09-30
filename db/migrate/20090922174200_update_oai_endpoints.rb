class UpdateOaiEndpoints < ActiveRecord::Migration
  def self.up
    add_column :oai_endpoints, :contributor_id, :integer
    add_column :oai_endpoints, :status, :integer
    add_column :oai_endpoints, :default_language_id, :integer
  end

  def self.down
    remove_column :oai_endpoints, :contributor_id
    remove_column :oai_endpoints, :status
    remove_column :oai_endpoints, :default_language_id
  end
end
