class AddSubjects < ActiveRecord::Migration
  def self.up
    create_table "subjects", :force => true do |t|
      t.text "name"
    end

    create_table "entries_subjects", :id => false, :force => true do |t|
      t.integer "entry_id", :null => false
      t.integer "subject_id"
    end

    add_index "entries_subjects", ["entry_id"], :name => "index_entries_subjects_on_entry_id"
    add_index "entries_subjects", ["subject_id"], :name => "index_entries_subjects_on_subject_id"
  
  end

  def self.down
    drop_table "subjects"
  end
end
