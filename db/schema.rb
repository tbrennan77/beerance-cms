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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131003164930) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bar_specials", force: true do |t|
    t.integer  "bar_id"
    t.integer  "beer_color"
    t.integer  "beer_size"
    t.datetime "expiration_date"
    t.decimal  "sale_price"
    t.string   "description"
    t.string   "parse_bar_special_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "bars", force: true do |t|
    t.integer  "user_id"
    t.integer  "subscription_plan_id"
    t.string   "stripe_customer_id"
    t.string   "name"
    t.string   "address"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "url"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "sunday_start"
    t.string   "sunday_end"
    t.string   "monday_start"
    t.string   "monday_end"
    t.string   "tuesday_start"
    t.string   "tuesday_end"
    t.string   "wednesday_start"
    t.string   "wednesday_end"
    t.string   "thursday_start"
    t.string   "thursday_end"
    t.string   "friday_start"
    t.string   "friday_end"
    t.string   "saturday_start"
    t.string   "saturday_end"
    t.string   "parse_bar_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "feedbacks", force: true do |t|
    t.integer  "user_id"
    t.string   "category"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meta_tags", force: true do |t|
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news_subscriptions", force: true do |t|
    t.string   "promoter_name"
    t.string   "subscriber_email"
    t.string   "subscriber_name"
    t.string   "subscriber_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "subscription_plans", force: true do |t|
    t.integer  "amount"
    t.string   "friendly_name"
    t.string   "image"
    t.integer  "length_in_months"
    t.string   "name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                   default: "",    null: false
    t.string   "encrypted_password",      default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "newsletter_subscription"
    t.string   "name"
    t.string   "phone"
    t.boolean  "admin",                   default: false, null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
