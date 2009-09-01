class AddPromptAndTemplateToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :prompt, :string
    add_column :services, :template, :string
  end

  def self.down
    remove_column :services, :prompt
    remove_column :services, :template
  end
end
