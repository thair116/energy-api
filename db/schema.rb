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

ActiveRecord::Schema.define(version: 20140125043502) do

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.date     "published_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "abstract"
    t.string   "url"
    t.integer  "shares"
  end

  create_table "articles_categories", force: true do |t|
    t.integer "article_id"
    t.integer "category_id"
  end

  add_index "articles_categories", ["article_id"], name: "index_articles_categories_on_article_id"
  add_index "articles_categories", ["category_id"], name: "index_articles_categories_on_category_id"

  create_table "authors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorships", force: true do |t|
    t.integer  "article_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorships", ["article_id"], name: "index_authorships_on_article_id"
  add_index "authorships", ["author_id"], name: "index_authorships_on_author_id"

  create_table "categories", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "body"
    t.string   "user"
    t.string   "user_location"
    t.integer  "stars"
    t.boolean  "pick"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id"

end
