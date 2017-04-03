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

ActiveRecord::Schema.define(version: 20170403121010) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "action"
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id", using: :btree
    t.index ["user_id"], name: "index_activities_on_user_id", using: :btree
  end

  create_table "dictionaries", force: :cascade do |t|
    t.string   "type",        limit: 20
    t.string   "title",       limit: 100
    t.integer  "words_count"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "word_id"
  end

  create_table "project_prototypes", force: :cascade do |t|
    t.string   "prototypable_type"
    t.integer  "prototypable_id"
    t.string   "name",              limit: 100
    t.jsonb    "structure"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "resources", force: :cascade do |t|
    t.integer  "name_id"
    t.integer  "category_id"
    t.string   "type"
    t.integer  "unit_id"
    t.decimal  "price_uah",   precision: 5,  scale: 2, default: "0.0"
    t.decimal  "price_usd",   precision: 5,  scale: 2, default: "0.0"
    t.decimal  "price_eur",   precision: 5,  scale: 2, default: "0.0"
    t.decimal  "count",       precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "shippings", force: :cascade do |t|
    t.string   "package_variant", limit: 20
    t.date     "shipping_date"
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
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.integer  "role"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "words", force: :cascade do |t|
    t.string   "body"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "dictionary_id"
  end

  add_foreign_key "activities", "users"
end
