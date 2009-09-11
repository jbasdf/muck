class CreateServiceCategories < ActiveRecord::Migration
  def self.up
    create_table :service_categories, :force => true do |t|
      t.string  'name', :null => false
      t.integer 'sort', :default => 0
    end
  end

  def self.down
    drop_table :service_categories
  end
end
