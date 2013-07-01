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

ActiveRecord::Schema.define(version: 20130928083538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "album_hierarchies", id: false, force: true do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "album_hierarchies", ["ancestor_id", "descendant_id"], name: "index_album_hierarchies_on_ancestor_id_and_descendant_id", unique: true, using: :btree
  add_index "album_hierarchies", ["descendant_id"], name: "index_album_hierarchies_on_descendant_id", using: :btree

  create_table "albums", force: true do |t|
    t.text     "description"
    t.boolean  "hidden",                          default: false
    t.string   "slug",                                                                null: false
    t.string   "title",                                                               null: false
    t.string   "thumbnail_url",       limit: 400, default: "/assets/placeholder.png", null: false
    t.integer  "images_count",                    default: 0,                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.date     "event_date"
    t.datetime "contents_updated_at"
  end

  add_index "albums", ["contents_updated_at"], name: "index_albums_on_contents_updated_at", using: :btree
  add_index "albums", ["hidden"], name: "index_albums_on_hidden", using: :btree
  add_index "albums", ["images_count"], name: "index_albums_on_images_count", using: :btree
  add_index "albums", ["parent_id"], name: "index_albums_on_parent_id", using: :btree
  add_index "albums", ["slug"], name: "index_albums_on_slug", unique: true, using: :btree

  create_table "archives", force: true do |t|
    t.string   "file"
    t.boolean  "processing",      default: false
    t.integer  "archivable_id"
    t.string   "archivable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "favorites", force: true do |t|
    t.integer  "favoritable_id"
    t.string   "favoritable_type"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  add_index "favorites", ["favoritable_id", "favoritable_type"], name: "index_favorites_on_favoritable_id_and_favoritable_type", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "images", force: true do |t|
    t.string   "image"
    t.integer  "album_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "md5"
    t.string   "store_dir"
    t.integer  "uploader_id"
  end

  add_index "images", ["album_id"], name: "index_images_on_album_id", using: :btree
  add_index "images", ["created_at"], name: "index_images_on_created_at", using: :btree
  add_index "images", ["md5"], name: "index_images_on_md5", using: :btree
  add_index "images", ["uploader_id"], name: "index_images_on_uploader_id", using: :btree

  create_table "images_sources", id: false, force: true do |t|
    t.integer "image_id"
    t.integer "source_id"
  end

  add_index "images_sources", ["image_id", "source_id"], name: "index_images_sources_on_image_id_and_source_id", unique: true, using: :btree

  create_table "sources", force: true do |t|
    t.text     "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "album_hierarchies", "albums", name: "album_hierarchies_ancestor_id_fk", column: "ancestor_id"
  add_foreign_key "album_hierarchies", "albums", name: "album_hierarchies_descendant_id_fk", column: "descendant_id"

  add_foreign_key "albums", "albums", name: "albums_parent_id_fk", column: "parent_id"

  add_foreign_key "comments", "users", name: "comments_user_id_fk"

  add_foreign_key "favorites", "users", name: "favorites_user_id_fk"

  add_foreign_key "images", "albums", name: "images_album_id_fk"
  add_foreign_key "images", "users", name: "images_uploader_id_fk", column: "uploader_id"

  add_foreign_key "images_sources", "images", name: "images_sources_image_id_fk"
  add_foreign_key "images_sources", "sources", name: "images_sources_source_id_fk"

end
