# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121005183147) do

  create_table "additional_fields", :force => true do |t|
    t.integer  "program_id",                 :null => false
    t.string   "short_name",  :limit => 100, :null => false
    t.string   "label"
    t.boolean  "is_required",                :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "additional_fields", ["program_id"], :name => "index_programs_additional_fields_on_program_id"

  create_table "photo_albums", :force => true do |t|
    t.integer  "program_id"
    t.string   "name"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "sort_photos_by", :limit => 25, :default => "position ASC", :null => false
  end

  add_index "photo_albums", ["program_id"], :name => "index_photo_albums_on_program_id"

  create_table "photo_tags", :force => true do |t|
    t.integer  "photo_id"
    t.string   "tag"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "photo_tags", ["photo_id"], :name => "index_photo_tags_on_photo_id"

  create_table "photos", :force => true do |t|
    t.string   "file"
    t.text     "caption"
    t.integer  "like_count"
    t.integer  "comment_count"
    t.string   "from_user_username"
    t.string   "from_user_full_name"
    t.string   "from_user_id"
    t.string   "from_service"
    t.string   "original_photo_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "position",                   :default => 0,    :null => false
    t.integer  "photo_album_id"
    t.boolean  "is_approved",                :default => true, :null => false
    t.string   "from_twitter_image_service"
    t.integer  "program_id"
  end

  create_table "program_photo_import_tags", :force => true do |t|
    t.integer  "program_id",               :null => false
    t.string   "tag",        :limit => 50, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "program_photo_import_tags", ["program_id"], :name => "index_program_photo_import_tags_on_program_id"

  create_table "programs", :force => true do |t|
    t.string   "name",                                              :null => false
    t.string   "description"
    t.string   "facebook_app_id"
    t.string   "facebook_app_secret"
    t.string   "google_analytics_tracking_code"
    t.string   "app_url"
    t.string   "repo"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.boolean  "active",                         :default => true,  :null => false
    t.datetime "set_active_date"
    t.datetime "set_inactive_date"
    t.string   "facebook_app_access_token"
    t.boolean  "facebook_is_like_gated"
    t.string   "short_name",                     :default => "",    :null => false
    t.string   "program_access_key",             :default => "",    :null => false
    t.boolean  "moderate_signups",               :default => false, :null => false
    t.string   "instagram_client_id"
    t.string   "instagram_client_secret"
    t.boolean  "moderate_photos"
    t.string   "twitter_consumer_key"
    t.string   "twitter_consumer_secret"
    t.string   "twitter_oauth_token"
    t.string   "twitter_oauth_token_secret"
    t.string   "tumblr_consumer_key"
    t.datetime "photos_updated_at"
    t.datetime "videos_updated_at"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "signups", :force => true do |t|
    t.string   "email",            :limit => 100, :null => false
    t.string   "first_name",       :limit => 50
    t.string   "last_name",        :limit => 50
    t.string   "address1"
    t.string   "address2"
    t.string   "city",             :limit => 40
    t.string   "state",            :limit => 2
    t.string   "zip",              :limit => 9
    t.string   "ip_address",       :limit => 15,  :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "program_id",                      :null => false
    t.string   "facebook_user_id"
    t.string   "country",          :limit => 2
    t.boolean  "is_valid"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "video_playlists", :force => true do |t|
    t.integer  "program_id"
    t.string   "name"
    t.string   "sort_videos_by", :limit => 25, :default => "position ASC", :null => false
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  add_index "video_playlists", ["program_id"], :name => "index_video_playlists_on_program_id"

  create_table "video_tags", :force => true do |t|
    t.integer  "video_id",                 :null => false
    t.string   "tag",        :limit => 50, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "video_tags", ["video_id"], :name => "index_video_tags_on_video_id"

  create_table "videos", :force => true do |t|
    t.text     "embed_code"
    t.text     "caption"
    t.integer  "position",          :default => 0,    :null => false
    t.boolean  "is_approved",       :default => true, :null => false
    t.string   "screenshot"
    t.integer  "video_playlist_id",                   :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "program_id"
    t.string   "embed_id"
    t.string   "title"
    t.string   "subtitle"
  end

end
