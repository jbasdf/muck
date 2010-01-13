class RenameActionTable < ActiveRecord::Migration
  def self.up
    rename_table :action_types, :attention_types
    rename_column :attention_types, :action_type, :name
    rename_column :attention_types, :weight, :default_weight

    change_column :attentions, :attentionable_type, :string, :default => 'User'
    rename_column :attentions, :action_type, :attention_type_id
    change_column :attentions, :attention_type_id, :integer
    change_column :attentions, :weight, :integer, :default => 5
    add_column :attentions, :created_at, :datetime
    add_index :attentions, :attention_type_id
    add_index :attentions, :entry_id

    remove_column :personal_recommendations, :rank
    add_column :personal_recommendations, :created_at, :datetime
    add_column :personal_recommendations, :visited_at, :datetime
    add_index :personal_recommendations, :personal_recommendable_id
  end

  def self.down
    remove_index :personal_recommendations, :personal_recommendable_id
    remove_column :personal_recommendations, :visited_at
    remove_column :personal_recommendations, :created_at
    add_column :personal_recommendations, :rank, :integer

    remove_index :attentions, :entry_id
    remove_index :attentions, :attention_type_id
    remove_column :attentions, :created_at
    change_column :attentions, :weight, :float
    change_column :attentions, :attention_type_id, :string
    rename_column :attentions, :attention_type_id, :action_type

    rename_column :attention_types, :default_weight, :weight
    rename_column :attention_types, :name, :action_type
    rename_table :attention_types, :action_types
  end
end
