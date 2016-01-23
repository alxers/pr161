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

ActiveRecord::Schema.define(version: 20160123151350) do

  create_table "advert_data", force: :cascade do |t|
    t.string   "campaign_name"
    t.string   "creative_name"
    t.date     "date"
    t.integer  "report_id"
    t.string   "type"
    t.date     "start_date"
    t.date     "end_date"
    t.float    "media_budget",  default: 0.0, null: false
    t.float    "media_spent",   default: 0.0, null: false
    t.integer  "impressions",   default: 0,   null: false
    t.integer  "clicks",        default: 0,   null: false
    t.float    "ctr",           default: 0.0, null: false
    t.integer  "conversions",   default: 0,   null: false
    t.integer  "campaign_id",   default: 0,   null: false
    t.float    "ecpm",          default: 0.0, null: false
    t.float    "ecpc",          default: 0.0, null: false
    t.float    "ecpa",          default: 0.0, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "advert_data", ["report_id"], name: "index_advert_data_on_report_id"

  create_table "reports", force: :cascade do |t|
    t.string   "campaign_name"
    t.date     "start_date"
    t.date     "end_date"
    t.float    "media_budget",  default: 0.0, null: false
    t.float    "media_spent",   default: 0.0, null: false
    t.integer  "impressions",   default: 0,   null: false
    t.integer  "clicks",        default: 0,   null: false
    t.float    "ctr",           default: 0.0, null: false
    t.integer  "conversions",   default: 0,   null: false
    t.integer  "campaign_id"
    t.string   "comment"
    t.float    "ecpm",          default: 0.0, null: false
    t.float    "ecpc",          default: 0.0, null: false
    t.float    "ecpa",          default: 0.0, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "token"
    t.boolean  "active",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
