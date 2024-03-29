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

ActiveRecord::Schema.define(version: 20140625144819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: true do |t|
    t.integer  "user_id"
    t.integer  "word_count"
    t.decimal  "reading_level"
    t.decimal  "avg_sentence_length"
    t.decimal  "avg_syllable_length"
    t.decimal  "avg_word_length"
    t.string   "title"
    t.string   "author"
    t.string   "raw_file_path"
    t.string   "parsed_file_path"
    t.string   "json_file_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "commenter_id"
    t.integer  "book_id"
    t.integer  "parent_id"
    t.text     "comment_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", force: true do |t|
    t.integer  "voter_id"
    t.integer  "book_id"
    t.integer  "up_or_down"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
