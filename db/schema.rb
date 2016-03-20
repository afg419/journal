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

ActiveRecord::Schema.define(version: 20160314204129) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_messages", force: :cascade do |t|
    t.text     "message"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "links"
  end

  add_index "app_messages", ["user_id"], name: "index_app_messages_on_user_id", using: :btree

  create_table "emotion_prototypes", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "color"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "emotions", force: :cascade do |t|
    t.integer  "score"
    t.integer  "journal_entry_id"
    t.integer  "emotion_prototype_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "emotions", ["emotion_prototype_id"], name: "index_emotions_on_emotion_prototype_id", using: :btree
  add_index "emotions", ["journal_entry_id"], name: "index_emotions_on_journal_entry_id", using: :btree

  create_table "journal_entries", force: :cascade do |t|
    t.string   "tag"
    t.string   "body"
    t.string   "file_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "journal_entries", ["user_id"], name: "index_journal_entries_on_user_id", using: :btree

  create_table "training_posts", force: :cascade do |t|
    t.text     "entry"
    t.string   "classification"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "user_emotion_prototypes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "emotion_prototype_id"
    t.string   "status",               default: "active"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "user_emotion_prototypes", ["emotion_prototype_id"], name: "index_user_emotion_prototypes_on_emotion_prototype_id", using: :btree
  add_index "user_emotion_prototypes", ["user_id"], name: "index_user_emotion_prototypes_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "permission_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "folder_id",     default: "No Folder"
  end

  add_foreign_key "app_messages", "users"
  add_foreign_key "emotions", "emotion_prototypes"
  add_foreign_key "emotions", "journal_entries"
  add_foreign_key "journal_entries", "users"
  add_foreign_key "user_emotion_prototypes", "emotion_prototypes"
  add_foreign_key "user_emotion_prototypes", "users"
end
