class NormalizeEntriesSubjects < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE entries_subjects DROP PRIMARY KEY, ADD PRIMARY KEY USING BTREE(subject_id, entry_id);"
    remove_column :entries_subjects, :language_id 
    remove_column :entries_subjects, :grain_size 
    execute "delete from entries_subjects where entry_id IN (select entries.id from entries inner join feeds ON feeds.id = entries.feed_id where feeds.uri = 'http://ndr.nsdl.org/oai?verb=ListRecords&metadataPrefix=nsdl_dc&set=439869');"
    execute "update feeds set last_harvested_at = '1969-01-01' where feeds.uri = 'http://ndr.nsdl.org/oai?verb=ListRecords&metadataPrefix=nsdl_dc&set=439869'"
  end

  def self.down
    add_column :entries_subjects, :language_id, :integer
    add_column :entries_subjects, :grain_size, :string
    add_index "entries_subjects", ["language_id"]
    add_index "entries_subjects", ["grain_size"]
    execute "ALTER TABLE entries_subjects DROP PRIMARY KEY, ADD PRIMARY KEY USING BTREE(subject_id, language_id, grain_size, entry_id);"
    execute "UPDATE entries_subjects AS es INNER JOIN entries AS e ON e.id = es.entry_id SET es.language_id = e.language_id, es.grain_size = e.grain_size"
  end
end
