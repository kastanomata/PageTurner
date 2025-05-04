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

ActiveRecord::Schema[8.0].define(version: 2025_05_04_123534) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "openlibrary_id"
    t.string "account_id"
    t.string "name"
  end

  create_table "bans", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "moderator_id", null: false
    t.text "reason"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["moderator_id"], name: "index_bans_on_moderator_id"
    t.index ["user_id"], name: "index_bans_on_user_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "isbn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "thumbnail"
    t.string "cover"
    t.string "poster"
    t.string "openlibrary_id"
    t.integer "author_id"
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
  end

  create_table "bookshelf_contains", force: :cascade do |t|
    t.string "bookshelf_id"
    t.string "creator_id"
    t.string "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bookshelf_id", "book_id"], name: "index_bookshelf_contains_on_bookshelf_and_book", unique: true
  end

  create_table "bookshelves", force: :cascade do |t|
    t.string "name"
    t.string "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bookclub"
    t.boolean "special"
  end

  create_table "clubs", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "curator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "post_id"
    t.text "text"
    t.string "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_likes_on_post_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "club_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_memberships_on_club_id"
    t.index ["follower_id", "club_id"], name: "index_memberships_on_follower_id_and_club_id", unique: true
    t.index ["follower_id"], name: "index_memberships_on_follower_id"
  end

  create_table "omni_auth_identities", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_omni_auth_identities_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "author_id"
    t.string "book_id"
    t.string "club_id"
    t.string "curator"
  end

  create_table "reading_goals", force: :cascade do |t|
    t.integer "club_id", null: false
    t.integer "book_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_reading_goals_on_book_id"
    t.index ["club_id"], name: "index_reading_goals_on_club_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "reporter_id"
    t.string "reported_id"
    t.string "reported_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "book_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id", "tag_id"], name: "index_taggings_on_book_id_and_tag_id", unique: true
    t.index ["book_id"], name: "index_taggings_on_book_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.string "description"
    t.string "birthday"
    t.boolean "admin"
    t.boolean "is_curator"
    t.integer "reading_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["reading_id"], name: "index_users_on_reading_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bans", "users"
  add_foreign_key "bans", "users", column: "moderator_id"
  add_foreign_key "books", "authors"
  add_foreign_key "likes", "posts"
  add_foreign_key "likes", "users"
  add_foreign_key "omni_auth_identities", "users"
  add_foreign_key "reading_goals", "books"
  add_foreign_key "reading_goals", "clubs"
  add_foreign_key "sessions", "users"
  add_foreign_key "taggings", "books"
  add_foreign_key "taggings", "tags"
  add_foreign_key "users", "books", column: "reading_id"
end
