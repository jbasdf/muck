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

ActiveRecord::Schema.define(:version => 20090517040220) do

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

  create_table "countries", :force => true do |t|
    t.string  "name",         :limit => 128, :default => "",   :null => false
    t.string  "abbreviation", :limit => 3,   :default => "",   :null => false
    t.integer "sort",                        :default => 1000, :null => false
  end

  add_index "countries", ["abbreviation"], :name => "index_countries_on_abbreviation"
  add_index "countries", ["name"], :name => "index_countries_on_name"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "permissions", :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "rolename"
    t.datetime "created_at"
    t.datetime "updated_at"
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

end
