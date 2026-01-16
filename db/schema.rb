# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_16_024254) do
  create_schema "analytics"
  create_schema "monitoring"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "public.books", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "author"
    t.datetime "created_at", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "public.entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.uuid "book_id", null: false
    t.datetime "created_at", null: false
    t.integer "crumbs", default: 0, null: false
    t.datetime "end_time"
    t.datetime "start_time"
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
  end

  create_table "public.notes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.uuid "entry_id", null: false
    t.datetime "updated_at", null: false
  end

  create_table "public.settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "public.user_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "enabled", default: false, null: false
    t.uuid "setting_id", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
  end

  create_table "public.users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "clerk_id"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.datetime "updated_at", null: false
    t.index ["clerk_id"], name: "index_users_on_clerk_id"
  end

  add_foreign_key "public.entries", "public.books"
  add_foreign_key "public.entries", "public.users"
  add_foreign_key "public.notes", "public.entries"
  add_foreign_key "public.user_settings", "public.settings"
  add_foreign_key "public.user_settings", "public.users"

  create_table "analytics.events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "event", null: false
    t.string "subject"
    t.datetime "updated_at", null: false
    t.index ["subject"], name: "index_events_on_subject"
  end

end
