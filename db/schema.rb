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

ActiveRecord::Schema.define(:version => 20091128170318) do

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
    t.integer  "comment_count",    :default => 0
    t.integer  "attachable_id"
    t.string   "attachable_type"
  end

  add_index "activities", ["attachable_id", "attachable_type"], :name => "index_activities_on_attachable_id_and_attachable_type"
  add_index "activities", ["item_id", "item_type"], :name => "index_activities_on_item_id_and_item_type"
  add_index "activities", ["source_id", "source_type"], :name => "index_activities_on_source_id_and_source_type"

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
    t.string  "feed_type",      :default => "Feed"
  end

  add_index "aggregation_feeds", ["aggregation_id"], :name => "index_aggregation_feeds_on_aggregation_id"
  add_index "aggregation_feeds", ["feed_id"], :name => "index_aggregation_feeds_on_feed_id"

  create_table "aggregations", :force => true do |t|
    t.string   "terms"
    t.string   "title"
    t.text     "description"
    t.text     "top_tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ownable_id"
    t.string   "ownable_type"
    t.integer  "feed_count",   :default => 0
  end

  add_index "aggregations", ["ownable_id", "ownable_type"], :name => "index_aggregations_on_ownable_id_and_ownable_type"

  create_table "attention_types", :force => true do |t|
    t.string  "name"
    t.integer "default_weight"
  end

  create_table "attentions", :force => true do |t|
    t.integer  "attentionable_id"
    t.string   "attentionable_type", :default => "User"
    t.integer  "entry_id"
    t.integer  "attention_type_id"
    t.integer  "weight",             :default => 5
    t.datetime "created_at"
  end

  add_index "attentions", ["attention_type_id"], :name => "index_attentions_on_attention_type_id"
  add_index "attentions", ["entry_id"], :name => "index_attentions_on_entry_id"

  create_table "blogs", :force => true do |t|
    t.integer  "blogable_id",   :default => 0
    t.string   "blogable_type", :default => ""
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blogs", ["blogable_id", "blogable_type"], :name => "index_blogs_on_blogable_id_and_blogable_type"

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

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",                 :default => 0
    t.string   "commentable_type", :limit => 15, :default => ""
    t.text     "body"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "is_denied",                      :default => 0,     :null => false
    t.boolean  "is_reviewed",                    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "content_permissions", :force => true do |t|
    t.integer  "content_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_permissions", ["content_id", "user_id"], :name => "index_content_permissions_on_content_id_and_user_id"

  create_table "content_translations", :force => true do |t|
    t.integer  "content_id"
    t.string   "title"
    t.text     "body"
    t.string   "locale"
    t.boolean  "user_edited", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_translations", ["content_id"], :name => "index_content_translations_on_content_id"
  add_index "content_translations", ["locale"], :name => "index_content_translations_on_locale"

  create_table "contents", :force => true do |t|
    t.integer  "creator_id"
    t.string   "title"
    t.text     "body"
    t.string   "locale"
    t.text     "body_raw"
    t.integer  "contentable_id"
    t.string   "contentable_type"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.boolean  "is_public"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "layout"
    t.integer  "comment_count",    :default => 0
  end

  add_index "contents", ["creator_id"], :name => "index_contents_on_creator_id"
  add_index "contents", ["parent_id"], :name => "index_contents_on_parent_id"

  create_table "countries", :force => true do |t|
    t.string  "name",         :limit => 128, :default => "",   :null => false
    t.string  "abbreviation", :limit => 3,   :default => "",   :null => false
    t.integer "sort",                        :default => 1000, :null => false
  end

  add_index "countries", ["abbreviation"], :name => "index_countries_on_abbreviation"
  add_index "countries", ["name"], :name => "index_countries_on_name"

  create_table "domain_themes", :force => true do |t|
    t.string "uri"
    t.string "name"
  end

  add_index "domain_themes", ["uri"], :name => "index_domain_themes_on_uri"

  create_table "entries", :force => true do |t|
    t.integer  "feed_id",                                                                    :null => false
    t.string   "permalink",               :limit => 2083, :default => "",                    :null => false
    t.string   "author",                  :limit => 2083
    t.text     "title",                                                                      :null => false
    t.text     "description"
    t.text     "content"
    t.boolean  "unique_content",                          :default => false
    t.datetime "published_at",                                                               :null => false
    t.datetime "entry_updated_at"
    t.datetime "harvested_at"
    t.string   "oai_identifier",          :limit => 2083
    t.integer  "language_id"
    t.string   "direct_link",             :limit => 2083
    t.datetime "indexed_at",                              :default => '1971-01-01 01:01:01', :null => false
    t.datetime "relevance_calculated_at",                 :default => '1971-01-01 01:01:01', :null => false
    t.text     "popular"
    t.text     "relevant"
    t.text     "other"
    t.string   "grain_size",                              :default => "unknown"
    t.integer  "comment_count",                           :default => 0
  end

  add_index "entries", ["direct_link"], :name => "index_entries_on_direct_link"
  add_index "entries", ["feed_id"], :name => "index_entries_on_feed_id"
  add_index "entries", ["grain_size"], :name => "index_entries_on_grain_size"
  add_index "entries", ["indexed_at"], :name => "index_entries_on_indexed_at"
  add_index "entries", ["language_id"], :name => "index_entries_on_language_id"
  add_index "entries", ["oai_identifier"], :name => "index_entries_on_oai_identifier"
  add_index "entries", ["permalink"], :name => "index_entries_on_permalink"
  add_index "entries", ["published_at"], :name => "index_entries_on_published_at"
  add_index "entries", ["relevance_calculated_at"], :name => "index_entries_on_relevance_calculated_at"

  create_table "entries_subjects", :id => false, :force => true do |t|
    t.integer "subject_id",    :default => 0,     :null => false
    t.integer "entry_id",      :default => 0,     :null => false
    t.boolean "autogenerated", :default => false
  end

  add_index "entries_subjects", ["autogenerated"], :name => "index_entries_subjects_on_autogenerated"
  add_index "entries_subjects", ["entry_id"], :name => "index_entries_subjects_on_entry_id"
  add_index "entries_subjects", ["subject_id"], :name => "index_entries_subjects_on_subject_id"

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

  create_table "feed_parents", :force => true do |t|
    t.integer  "feed_id"
    t.integer  "ownable_id"
    t.string   "ownable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_parents", ["feed_id"], :name => "index_feed_parents_on_feed_id"
  add_index "feed_parents", ["ownable_id", "ownable_type"], :name => "index_feed_parents_on_ownable_id_and_ownable_type"

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
    t.integer  "service_id",                                 :default => 0
    t.string   "login"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "entries_changed_at"
    t.string   "harvested_from_display_uri", :limit => 2083
    t.string   "harvested_from_title",       :limit => 1000
    t.string   "harvested_from_short_title", :limit => 100
    t.integer  "entries_count"
    t.integer  "default_language_id",                        :default => 0
    t.string   "default_grain_size",                         :default => "unknown"
    t.integer  "contributor_id"
    t.string   "etag"
  end

  add_index "feeds", ["service_id"], :name => "index_feeds_on_service_id"
  add_index "feeds", ["uri"], :name => "index_feeds_on_uri"

  create_table "friends", :force => true do |t|
    t.integer  "inviter_id"
    t.integer  "invited_id"
    t.integer  "status",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friends", ["invited_id", "inviter_id"], :name => "index_friends_on_invited_id_and_inviter_id"
  add_index "friends", ["inviter_id", "invited_id"], :name => "index_friends_on_inviter_id_and_invited_id"

  create_table "identity_feeds", :force => true do |t|
    t.integer "feed_id",      :null => false
    t.integer "ownable_id",   :null => false
    t.string  "ownable_type", :null => false
  end

  add_index "identity_feeds", ["ownable_id", "ownable_type"], :name => "index_identity_feeds_on_ownable_id_and_ownable_type"

  create_table "invitees", :force => true do |t|
    t.string "email", :null => false
  end

  add_index "invitees", ["email"], :name => "index_invites_on_email"

  create_table "invites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "invitee_id",   :null => false
    t.integer  "inviter_id",   :null => false
    t.string   "inviter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["inviter_id", "inviter_type"], :name => "index_invites_on_inviter_id_and_inviter_type"

  create_table "languages", :force => true do |t|
    t.string  "name"
    t.string  "english_name"
    t.string  "locale"
    t.boolean "supported",            :default => true
    t.integer "is_default",           :default => 0
    t.boolean "muck_raker_supported", :default => false
    t.integer "indexed_records",      :default => 0
  end

  add_index "languages", ["locale"], :name => "index_languages_on_locale"
  add_index "languages", ["muck_raker_supported"], :name => "index_languages_on_muck_raker_supported"
  add_index "languages", ["name"], :name => "index_languages_on_name"

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
    t.string   "uri",                 :limit => 2083
    t.string   "display_uri",         :limit => 2083
    t.string   "metadata_prefix"
    t.string   "title",               :limit => 1000
    t.string   "short_title",         :limit => 100
    t.integer  "contributor_id"
    t.integer  "status"
    t.integer  "default_language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personal_recommendations", :force => true do |t|
    t.integer  "personal_recommendable_id"
    t.string   "personal_recommendable_type"
    t.integer  "destination_id"
    t.string   "destination_type"
    t.float    "relevance"
    t.datetime "created_at"
    t.datetime "visited_at"
  end

  add_index "personal_recommendations", ["personal_recommendable_id"], :name => "index_personal_recommendations_on_personal_recommendable_id"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.decimal  "lat",                :precision => 15, :scale => 10
    t.decimal  "lng",                :precision => 15, :scale => 10
    t.text     "about"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city"
    t.integer  "state_id"
    t.integer  "country_id"
    t.integer  "language_id"
  end

  add_index "profiles", ["lat", "lng"], :name => "index_profiles_on_lat_and_lng"
  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

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

  create_table "service_categories", :force => true do |t|
    t.string  "name",                :null => false
    t.integer "sort", :default => 0
  end

  create_table "services", :force => true do |t|
    t.string  "uri",                 :limit => 2083, :default => ""
    t.string  "name",                :limit => 1000, :default => ""
    t.string  "api_uri",             :limit => 2083, :default => ""
    t.string  "uri_template",        :limit => 2083, :default => ""
    t.string  "icon",                :limit => 2083, :default => "rss.gif"
    t.integer "sort"
    t.boolean "requires_password",                   :default => false
    t.string  "use_for"
    t.integer "service_category_id"
    t.boolean "active",                              :default => true
    t.string  "prompt"
    t.string  "template"
    t.string  "uri_data_template",   :limit => 2083, :default => ""
    t.string  "uri_key"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shares", :force => true do |t|
    t.string   "uri",           :limit => 2083, :default => "", :null => false
    t.string   "title"
    t.text     "message"
    t.integer  "shared_by_id",                                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comment_count",                 :default => 0
    t.integer  "entry_id"
  end

  add_index "shares", ["shared_by_id"], :name => "index_shares_on_shared_by_id"
  add_index "shares", ["uri"], :name => "index_shares_on_uri"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_name_and_sluggable_type_and_scope_and_sequence", :unique => true
  add_index "slugs", ["scope"], :name => "index_slugs_on_scope"
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "states", :force => true do |t|
    t.string  "name",         :limit => 128, :default => "", :null => false
    t.string  "abbreviation", :limit => 3,   :default => "", :null => false
    t.integer "country_id",   :limit => 8,                   :null => false
  end

  add_index "states", ["abbreviation"], :name => "index_states_on_abbreviation"
  add_index "states", ["country_id"], :name => "index_states_on_country_id"
  add_index "states", ["name"], :name => "index_states_on_name"

  create_table "subjects", :force => true do |t|
    t.string "name"
  end

  create_table "tag_clouds", :force => true do |t|
    t.integer "language_id"
    t.string  "filter"
    t.string  "tag_list",    :limit => 5000
    t.string  "grain_size",                  :default => "all"
  end

  add_index "tag_clouds", ["grain_size", "language_id", "filter"], :name => "index_tag_clouds_on_grain_size_and_language_id_and_filter", :unique => true

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
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "themes", :force => true do |t|
    t.string "name"
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
