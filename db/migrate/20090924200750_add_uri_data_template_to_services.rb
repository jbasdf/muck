class AddUriDataTemplateToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :uri_data_template, :string, :limit => 2083, :default => ""
  end

  def self.down
    remove_column :services, :uri_data_template
  end
end
