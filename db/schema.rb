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

ActiveRecord::Schema.define(:version => 20120803153900) do

  create_table "programs", :force => true do |t|
    t.string   "name",                                              :null => false
    t.string   "description"
    t.string   "state"
    t.string   "facebook_app_id"
    t.string   "facebook_app_secret"
    t.string   "google_analytics_tracking_code"
    t.string   "production"
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
    t.boolean  "set_signups_to_valid",           :default => false, :null => false
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
    t.hstore   "fields"
    t.integer  "program_id",                      :null => false
    t.string   "facebook_user_id"
    t.string   "country",          :limit => 2
    t.boolean  "is_valid"
  end

  add_index "signups", ["fields"], :name => "signups_fields"

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

end
