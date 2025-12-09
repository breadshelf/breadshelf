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

ActiveRecord::Schema[8.1].define(version: 2025_12_09_040701) do
  create_schema "analytics"
  create_schema "monitoring"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "public.books", force: :cascade do |t|
    t.string "author"
    t.datetime "created_at", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "public.entries", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "book_id", null: false
    t.datetime "created_at", null: false
    t.integer "crumbs", default: 0, null: false
    t.datetime "end_time"
    t.datetime "start_time"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["book_id"], name: "index_entries_on_book_id"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "public.notes", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "entry_id", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_id"], name: "index_notes_on_entry_id"
  end

  create_table "public.users", force: :cascade do |t|
    t.string "clerk_id"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.uuid "unique_id"
    t.datetime "updated_at", null: false
    t.index ["clerk_id"], name: "index_users_on_clerk_id"
    t.index ["unique_id"], name: "index_users_on_unique_id"
  end

  add_foreign_key "public.entries", "public.books"
  add_foreign_key "public.entries", "public.users"
  add_foreign_key "public.notes", "public.entries"

  create_table "analytics.events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "event", null: false
    t.string "subject"
    t.datetime "updated_at", null: false
  end

end
