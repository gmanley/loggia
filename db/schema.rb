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

ActiveRecord::Schema.define(:version => 20130109222826) do

  create_table "album_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id",   :null => false
    t.integer "descendant_id", :null => false
    t.integer "generations",   :null => false
  end

  add_index "album_hierarchies", ["ancestor_id", "descendant_id"], :name => "index_album_hierarchies_on_ancestor_id_and_descendant_id", :unique => true
  add_index "album_hierarchies", ["descendant_id"], :name => "index_album_hierarchies_on_descendant_id"

  create_table "albums", :force => true do |t|
    t.text     "description"
    t.boolean  "hidden",        :default => false
    t.string   "slug",                                                 :null => false
    t.string   "title",                                                :null => false
    t.string   "thumbnail_url", :default => "/assets/placeholder.png", :null => false
    t.integer  "images_count",  :default => 0,                         :null => false
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.integer  "parent_id"
    t.date     "event_date"
  end

  add_index "albums", ["hidden"], :name => "index_albums_on_hidden"
  add_index "albums", ["images_count"], :name => "index_albums_on_images_count"
  add_index "albums", ["parent_id"], :name => "index_albums_on_parent_id"
  add_index "albums", ["slug"], :name => "index_albums_on_slug", :unique => true

  create_table "archives", :force => true do |t|
    t.string   "file"
    t.boolean  "processing",      :default => false
    t.integer  "archivable_id"
    t.string   "archivable_type"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "favorites", :force => true do |t|
    t.text     "body"
    t.integer  "favoritable_id"
    t.string   "favoritable_type"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  add_index "favorites", ["favoritable_id", "favoritable_type"], :name => "index_favorites_on_favoritable_id_and_favoritable_type"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "images", :force => true do |t|
    t.string   "image"
    t.integer  "album_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "md5"
    t.string   "store_dir"
    t.integer  "source_id"
    t.integer  "photographer_id"
    t.integer  "uploader_id"
  end

  add_index "images", ["album_id"], :name => "index_images_on_album_id"
  add_index "images", ["md5"], :name => "index_images_on_md5"
  add_index "images", ["photographer_id"], :name => "index_images_on_photographer_id"
  add_index "images", ["source_id"], :name => "index_images_on_source_id"
  add_index "images", ["uploader_id"], :name => "index_images_on_uploader_id"

  create_table "photographers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "admin"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
