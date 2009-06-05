class CreateMuckRaker < ActiveRecord::Migration

  def self.up

    create_table "action_types", :force => true do |t|
      t.string  "action_type"
      t.integer "weight"
    end

    create_table "aggregation_feeds", :force => true do |t|
      t.integer "aggregation_id"
      t.integer "feed_id"
    end

    add_index "aggregation_feeds", ["aggregation_id"]
    add_index "aggregation_feeds", ["feed_id"]

    create_table "aggregations", :force => true do |t|
      t.string   "name"
      t.string   "title"
      t.text     "description"
      t.text     "top_tags"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "aggregations", ["user_id"]

    create_table "attentions", :force => true do |t|
      t.integer "attentionable_id"
      t.string  "attentionable_type"
      t.integer "entry_id"
      t.string  "action_type"
      t.float   "weight"
    end

    create_table "clicks", :force => true do |t|
      t.integer  "recommendation_id"
      t.datetime "when",                              :null => false
      t.string   "referrer",          :limit => 2083
      t.string   "requester"
      t.string   "user_agent",        :limit => 2083
    end

    add_index "clicks", ["recommendation_id"]
    add_index "clicks", ["referrer"]
    add_index "clicks", ["requester"]
    add_index "clicks", ["user_agent"]
    add_index "clicks", ["when"]

    create_table "entries", :force => true do |t|
      t.integer  "feed_id",                                                                    :null => false
      t.string   "permalink",               :limit => 2083, :default => "",                    :null => false
      t.string   "author",                  :limit => 2083
      t.text     "title",                                                                      :null => false
      t.text     "description"
      t.text     "content"
      t.boolean  "unique_content",                          :default => false
      t.text     "tag_list"
      t.datetime "published_at",                                                               :null => false
      t.datetime "entry_updated_at"
      t.datetime "harvested_at"
      t.string   "oai_identifier",          :limit => 2083
      t.boolean  "recommender_processed",                   :default => false
      t.integer  "language_id"
      t.string   "direct_link",             :limit => 2083
      t.datetime "indexed_at",                              :default => '1971-01-01 01:01:01', :null => false
      t.datetime "relevance_calculated_at",                 :default => '1971-01-01 01:01:01', :null => false
      t.text     "popular"
      t.text     "relevant"
      t.text     "other"
    end

    add_index "entries", ["direct_link"]
    add_index "entries", ["feed_id"]
    add_index "entries", ["indexed_at"]
    add_index "entries", ["language_id"]
    add_index "entries", ["oai_identifier"]
    add_index "entries", ["permalink"]
    add_index "entries", ["published_at"]
    add_index "entries", ["recommender_processed"]
    add_index "entries", ["relevance_calculated_at"]

    create_table "entries_subjects", :id => false, :force => true do |t|
      t.integer "entry_id",   :null => false
      t.integer "subject_id"
    end

    add_index "entries_subjects", ["entry_id"]
    add_index "entries_subjects", ["subject_id"]
    
    create_table "entries_tags", :id => false, :force => true do |t|
	  t.integer "entry_id", :null => false
	  t.integer "tag_id"
    end

    add_index "entries_tags", ["entry_id"]
    add_index "entries_tags", ["tag_id"]

    create_table "entries_users", :force => true do |t|
      t.integer  "entry_id",                           :null => false
      t.integer  "user_id",         :default => 0
      t.boolean  "clicked_through", :default => false
      t.datetime "created_at"
    end

    add_index "entries_users", ["entry_id", "user_id"]
    add_index "entries_users", ["entry_id"]
    add_index "entries_users", ["user_id"]

    create_table "entry_images", :force => true do |t|
      t.integer "entry_id"
      t.string  "uri",      :limit => 2083
      t.string  "link",     :limit => 2083
      t.string  "alt"
      t.string  "title"
      t.integer "width"
      t.integer "height"
    end

    add_index "entry_images", ["entry_id"]

    create_table "feeds", :force => true do |t|
      t.string   "uri",                        :limit => 2083
      t.string   "display_uri",                :limit => 2083
      t.string   "title",                      :limit => 1000
      t.string   "short_title",                :limit => 100
      t.text     "description"
      t.string   "tag_filter",                 :limit => 1000
      t.text     "top_tags"
      t.integer  "priority",                                   :default => 10
      t.integer  "status",                                     :default => 1
      t.datetime "last_requested_at"
      t.datetime "last_harvested_at"
      t.integer  "harvest_interval",                           :default => 86400
      t.integer  "failed_requests",                            :default => 0
      t.text     "error_message"
      t.integer  "service_id",                                 :default => 0,     :null => false
      t.string   "login"
      t.string   "password"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "entries_changed_at"
      t.string   "harvested_from_display_uri", :limit => 2083
      t.string   "harvested_from_title",       :limit => 1000
      t.string   "harvested_from_short_title", :limit => 100
      t.integer  "entries_count"
      t.integer  "default_language_id", :default => 0
    end

    add_index "feeds", ["service_id"]
    add_index "feeds", ["uri"]

    create_table "micro_concerts", :force => true do |t|
      t.integer "micro_event_id"
      t.string  "performer"
      t.string  "ticket_url",     :limit => 2083
    end

    add_index "micro_concerts", ["micro_event_id"]

    create_table "micro_conferences", :force => true do |t|
      t.integer  "micro_event_id"
      t.string   "theme"
      t.datetime "register_by"
      t.datetime "submit_by"
    end

    add_index "micro_conferences", ["micro_event_id"]

    create_table "micro_event_links", :force => true do |t|
      t.integer "micro_event_id"
      t.string  "uri"
      t.string  "title"
    end

    add_index "micro_event_links", ["micro_event_id"]

    create_table "micro_event_people", :force => true do |t|
      t.integer "micro_event_id"
      t.string  "name"
      t.string  "role"
      t.string  "email"
      t.string  "link",           :limit => 2083
      t.string  "phone"
    end

    add_index "micro_event_people", ["micro_event_id"]

    create_table "micro_events", :force => true do |t|
      t.integer  "entry_id",    :null => false
      t.string   "name",        :null => false
      t.text     "description"
      t.string   "price"
      t.text     "image"
      t.text     "address"
      t.text     "subaddress"
      t.string   "city"
      t.string   "state"
      t.string   "postcode"
      t.string   "country"
      t.datetime "begins",      :null => false
      t.datetime "ends"
      t.text     "tags"
      t.string   "duration"
      t.text     "location"
    end

    add_index "micro_events", ["entry_id"]

    create_table "oai_endpoints", :force => true do |t|
      t.string "uri",             :limit => 2083
      t.string "display_uri",     :limit => 2083
      t.string "metadata_prefix"
      t.string "title",           :limit => 1000
      t.string "short_title",     :limit => 100
    end

    create_table "personal_recommendations", :force => true do |t|
      t.integer "personal_recommendable_id"
      t.string  "personal_recommendable_type"
      t.integer "destination_id"
      t.string  "destination_type"
      t.integer "rank"
      t.float   "relevance"
    end

    create_table "queries", :force => true do |t|
      t.text    "name"
      t.integer "frequency"
    end

    create_table "recommendations", :force => true do |t|
      t.integer "entry_id"
      t.integer "dest_entry_id"
      t.integer "rank"
      t.decimal "relevance",        :precision => 8, :scale => 6, :default => 0.0
      t.integer "clicks",                                         :default => 0
      t.integer "avg_time_at_dest",                               :default => 60
    end

    add_index "recommendations", ["dest_entry_id"]
    add_index "recommendations", ["entry_id"]

    create_table "services", :force => true do |t|
      t.string  "uri",               :limit => 2083, :default => "",    :null => false
      t.string  "title",             :limit => 1000, :default => "",    :null => false
      t.string  "api_uri",           :limit => 2083, :default => "",    :null => false
      t.string  "uri_template",      :limit => 2083, :default => "",    :null => false
      t.string  "icon",              :limit => 2083
      t.integer "sequence"
      t.boolean "requires_password",                 :default => false
    end

    create_table "subjects", :force => true do |t|
      t.text "name"
    end

    create_table "watched_pages", :force => true do |t|
      t.integer  "entry_id"
      t.datetime "harvested_at"
      t.boolean  "has_microformats", :default => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "watched_pages", ["entry_id"]

    # modify the tags table
    add_column :tags, :stem, :string
    add_column :tags, :frequency, :integer
    add_column :tags, :root, :boolean
    add_column :tags, :stem_frequency, :integer

    add_index "tags", ["stem"]
    add_index "tags", ["frequency"]
    add_index "tags", ["root"]

    # add a flag to the languages table to flag languages we support
    add_column :languages, :muck_raker_supported, :boolean, :default => false
    add_column :languages, :indexed_records, :integer, :default => false
    add_index "languages", ["muck_raker_supported"]
    add_index "languages", ["indexed_records"]
  end

  def self.down
    drop_table :action_types
    drop_table :aggregation_feeds
    drop_table :aggregation_top_tags
    drop_table :aggregations
    drop_table :attentions
    drop_table :clicks
    drop_table :entries
    drop_table :entries_subjects
    drop_table :entries_users
    drop_table :entry_images
    drop_table :feeds
    drop_table :interests
    drop_table :recommender_languages
    drop_table :micro_concerts
    drop_table :micro_conferences
    drop_table :micro_event_links   
    drop_table :micro_event_people
    drop_table :micro_events
    drop_table :oai_endpoints
    drop_table :personal_recommendations
    drop_table :queries
    drop_table :recommendations
    drop_table :services
    drop_table :subjects
    drop_table :watched_pages
    drop_table :entries_tags

    remove_column :tags, :stem
    remove_column :tags, :frequency
    remove_column :tags, :root
    remove_column :tags, :stem_frequency
  end

end