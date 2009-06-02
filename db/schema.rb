# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090602191243) do

  create_table "action_types", :force => true do |t|
    t.string  "action_type"
    t.integer "weight"
  end

  create_table "activities", :force => true do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.string   "template"
    t.integer  "source_id"
    t.string   "source_type"
    t.text     "content"
    t.string   "title"
    t.boolean  "is_status_update", :default => false
    t.boolean  "is_public",        :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["item_id", "item_type"], :name => "index_activities_on_item_id_and_item_type"

  create_table "activity_feeds", :force => true do |t|
    t.integer "activity_id"
    t.integer "ownable_id"
    t.string  "ownable_type"
  end

  add_index "activity_feeds", ["activity_id"], :name => "index_activity_feeds_on_activity_id"
  add_index "activity_feeds", ["ownable_id", "ownable_type"], :name => "index_activity_feeds_on_ownable_id_and_ownable_type"

  create_table "aggregation_feeds", :force => true do |t|
    t.integer "aggregation_id"
    t.integer "feed_id"
  end

  add_index "aggregation_feeds", ["aggregation_id"], :name => "index_aggregation_feeds_on_aggregation_id"
  add_index "aggregation_feeds", ["feed_id"], :name => "index_aggregation_feeds_on_feed_id"

  create_table "aggregations", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "description"
    t.text     "top_tags"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aggregations", ["user_id"], :name => "index_aggregations_on_user_id"

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

  add_index "clicks", ["recommendation_id"], :name => "index_clicks_on_recommendation_id"
  add_index "clicks", ["referrer"], :name => "index_clicks_on_referrer"
  add_index "clicks", ["requester"], :name => "index_clicks_on_requester"
  add_index "clicks", ["user_agent"], :name => "index_clicks_on_user_agent"
  add_index "clicks", ["when"], :name => "index_clicks_on_when"

  create_table "countries", :force => true do |t|
    t.string  "name",         :limit => 128, :default => "",   :null => false
    t.string  "abbreviation", :limit => 3,   :default => "",   :null => false
    t.integer "sort",                        :default => 1000, :null => false
  end

  add_index "countries", ["abbreviation"], :name => "index_countries_on_abbreviation"
  add_index "countries", ["name"], :name => "index_countries_on_name"

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
    t.string   "language"
    t.string   "direct_link",             :limit => 2083
    t.datetime "indexed_at",                              :default => '1971-01-01 01:01:01', :null => false
    t.datetime "relevance_calculated_at",                 :default => '1971-01-01 01:01:01', :null => false
    t.text     "popular"
    t.text     "relevant"
    t.text     "other"
  end

  add_index "entries", ["direct_link"], :name => "index_entries_on_direct_link"
  add_index "entries", ["feed_id"], :name => "index_entries_on_feed_id"
  add_index "entries", ["indexed_at"], :name => "index_entries_on_indexed_at"
  add_index "entries", ["language"], :name => "index_entries_on_language"
  add_index "entries", ["oai_identifier"], :name => "index_entries_on_oai_identifier"
  add_index "entries", ["permalink"], :name => "index_entries_on_permalink"
  add_index "entries", ["published_at"], :name => "index_entries_on_published_at"
  add_index "entries", ["recommender_processed"], :name => "index_entries_on_recommender_processed"
  add_index "entries", ["relevance_calculated_at"], :name => "index_entries_on_relevance_calculated_at"

  create_table "entries_subjects", :id => false, :force => true do |t|
    t.integer "entry_id",   :null => false
    t.integer "subject_id"
  end

  add_index "entries_subjects", ["entry_id"], :name => "index_entries_subjects_on_entry_id"
  add_index "entries_subjects", ["subject_id"], :name => "index_entries_subjects_on_subject_id"

  create_table "entries_tags", :id => false, :force => true do |t|
    t.integer "entry_id", :null => false
    t.integer "tag_id"
  end

  add_index "entries_tags", ["entry_id"], :name => "index_entries_tags_on_entry_id"
  add_index "entries_tags", ["tag_id"], :name => "index_entries_tags_on_tag_id"

  create_table "entries_users", :force => true do |t|
    t.integer  "entry_id",                           :null => false
    t.integer  "user_id",         :default => 0
    t.boolean  "clicked_through", :default => false
    t.datetime "created_at"
  end

  add_index "entries_users", ["entry_id", "user_id"], :name => "index_entries_users_on_entry_id_and_user_id"
  add_index "entries_users", ["entry_id"], :name => "index_entries_users_on_entry_id"
  add_index "entries_users", ["user_id"], :name => "index_entries_users_on_user_id"

  create_table "entry_images", :force => true do |t|
    t.integer "entry_id"
    t.string  "uri",      :limit => 2083
    t.string  "link",     :limit => 2083
    t.string  "alt"
    t.string  "title"
    t.integer "width"
    t.integer "height"
  end

  add_index "entry_images", ["entry_id"], :name => "index_entry_images_on_entry_id"

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
    t.string   "default_language"
  end

  add_index "feeds", ["service_id"], :name => "index_feeds_on_service_id"
  add_index "feeds", ["uri"], :name => "index_feeds_on_uri"

  create_table "micro_concerts", :force => true do |t|
    t.integer "micro_event_id"
    t.string  "performer"
    t.string  "ticket_url",     :limit => 2083
  end

  add_index "micro_concerts", ["micro_event_id"], :name => "index_micro_concerts_on_micro_event_id"

  create_table "micro_conferences", :force => true do |t|
    t.integer  "micro_event_id"
    t.string   "theme"
    t.datetime "register_by"
    t.datetime "submit_by"
  end

  add_index "micro_conferences", ["micro_event_id"], :name => "index_micro_conferences_on_micro_event_id"

  create_table "micro_event_links", :force => true do |t|
    t.integer "micro_event_id"
    t.string  "uri"
    t.string  "title"
  end

  add_index "micro_event_links", ["micro_event_id"], :name => "index_micro_event_links_on_micro_event_id"

  create_table "micro_event_people", :force => true do |t|
    t.integer "micro_event_id"
    t.string  "name"
    t.string  "role"
    t.string  "email"
    t.string  "link",           :limit => 2083
    t.string  "phone"
  end

  add_index "micro_event_people", ["micro_event_id"], :name => "index_micro_event_people_on_micro_event_id"

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

  add_index "micro_events", ["entry_id"], :name => "index_micro_events_on_entry_id"

  create_table "oai_endpoints", :force => true do |t|
    t.string "uri",             :limit => 2083
    t.string "display_uri",     :limit => 2083
    t.string "metadata_prefix"
    t.string "title",           :limit => 1000
    t.string "short_title",     :limit => 100
  end

  create_table "permissions", :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
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

  add_index "recommendations", ["dest_entry_id"], :name => "index_recommendations_on_dest_entry_id"
  add_index "recommendations", ["entry_id"], :name => "index_recommendations_on_entry_id"

  create_table "roles", :force => true do |t|
    t.string   "rolename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", :force => true do |t|
    t.string  "uri",               :limit => 2083, :default => "",    :null => false
    t.string  "title",             :limit => 1000, :default => "",    :null => false
    t.string  "api_uri",           :limit => 2083, :default => "",    :null => false
    t.string  "uri_template",      :limit => 2083, :default => "",    :null => false
    t.string  "icon",              :limit => 2083
    t.integer "sequence"
    t.boolean "requires_password",                 :default => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "states", :force => true do |t|
    t.string  "name",         :limit => 128, :default => "", :null => false
    t.string  "abbreviation", :limit => 3,   :default => "", :null => false
    t.integer "country_id",   :limit => 8,                   :null => false
  end

  add_index "states", ["abbreviation"], :name => "index_states_on_abbreviation"
  add_index "states", ["country_id"], :name => "index_states_on_country_id"
  add_index "states", ["name"], :name => "index_states_on_name"

  create_table "subjects", :force => true do |t|
    t.text "name"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.string  "stem"
    t.integer "frequency"
    t.boolean "root"
    t.integer "stem_frequency"
  end

  add_index "tags", ["frequency"], :name => "index_tags_on_frequency"
  add_index "tags", ["root"], :name => "index_tags_on_root"
  add_index "tags", ["stem"], :name => "index_tags_on_stem"

  create_table "themes", :force => true do |t|
    t.string "current"
  end

  create_table "uploads", :force => true do |t|
    t.integer  "creator_id"
    t.string   "name"
    t.string   "caption",             :limit => 1000
    t.text     "description"
    t.boolean  "is_public",                           :default => true
    t.integer  "uploadable_id"
    t.string   "uploadable_type"
    t.string   "width"
    t.string   "height"
    t.string   "local_file_name"
    t.string   "local_content_type"
    t.integer  "local_file_size"
    t.datetime "local_updated_at"
    t.string   "remote_file_name"
    t.string   "remote_content_type"
    t.integer  "remote_file_size"
    t.datetime "remote_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uploads", ["creator_id"], :name => "index_uploads_on_creator_id"
  add_index "uploads", ["local_content_type"], :name => "index_uploads_on_local_content_type"
  add_index "uploads", ["uploadable_id"], :name => "index_uploads_on_uploadable_id"
  add_index "uploads", ["uploadable_type"], :name => "index_uploads_on_uploadable_type"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "terms_of_service",    :default => false, :null => false
    t.string   "time_zone",           :default => "UTC"
    t.datetime "disabled_at"
    t.datetime "activated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["single_access_token"], :name => "index_users_on_single_access_token"

  create_table "watched_pages", :force => true do |t|
    t.integer  "entry_id"
    t.datetime "harvested_at"
    t.boolean  "has_microformats", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "watched_pages", ["entry_id"], :name => "index_watched_pages_on_entry_id"

end
