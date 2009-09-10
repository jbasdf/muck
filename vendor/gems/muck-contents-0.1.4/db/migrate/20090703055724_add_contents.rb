class AddContents < ActiveRecord::Migration
  def self.up
    create_table :contents, :force => true do |t|
      t.integer  :creator_id
      t.string   :title
      t.text     :body
      t.string   :locale
      t.text     :body_raw
      t.integer  :contentable_id
      t.string   :contentable_type
      t.integer  :parent_id
      t.integer  :lft
      t.integer  :rgt
      t.boolean  :is_public
      t.string   :state
      t.timestamps
    end

    create_table :content_translations, :force => true do |t|
      t.integer  :content_id
      t.string   :title
      t.text     :body
      t.string   :locale
      t.boolean  :user_edited, :default => false
      t.timestamps
    end
    
    create_table :content_permissions, :force => true do |t|
      t.integer  :content_id
      t.integer  :user_id
      t.timestamps
    end
    
    add_index :contents, :parent_id
    add_index :contents, :creator_id
    
    add_index :content_translations, :content_id
    add_index :content_translations, :locale
    
    add_index :content_permissions, [:content_id, :user_id]
  end

  def self.down
    drop_table :content_versions
    drop_table :contents
    drop_table :content_translations
    drop_table :content_permissions
  end
end
