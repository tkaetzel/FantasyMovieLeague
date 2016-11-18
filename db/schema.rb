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

ActiveRecord::Schema.define(version: 20161118032204) do

  create_table "earnings", force: :cascade do |t|
    t.integer  "movie_id"
    t.integer  "gross"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "mapped_name",            limit: 255
    t.text     "plot"
    t.string   "actors",                 limit: 255
    t.datetime "release_date"
    t.string   "imdb",                   limit: 255
    t.string   "director",               limit: 255
    t.integer  "rating"
    t.integer  "rotten_tomatoes_id"
    t.integer  "rotten_tomatoes_rating"
    t.integer  "season_id",                          default: 0,     null: false
    t.boolean  "limited",                            default: false, null: false
    t.integer  "percent_limit"
    t.string   "rotten_tomatoes_url"
  end

  create_table "players", force: :cascade do |t|
    t.string   "long_name",  limit: 255
    t.string   "short_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bonus1"
    t.integer  "bonus2"
    t.integer  "season_id",              default: 0, null: false
  end

  create_table "players_teams", id: false, force: :cascade do |t|
    t.integer "player_id", null: false
    t.integer "team_id",   null: false
  end

  create_table "seasons", force: :cascade do |t|
    t.string  "name",               limit: 255
    t.string  "page_title",         limit: 255
    t.string  "slug",               limit: 255
    t.integer "bonus_amount",                   default: 0, null: false
    t.string  "new_header_content"
  end

  create_table "shares", force: :cascade do |t|
    t.integer "player_id"
    t.integer "movie_id"
    t.integer "num_shares"
  end

  create_table "teams", force: :cascade do |t|
    t.string  "name",      limit: 255
    t.integer "season_id",                          null: false
    t.string  "slug",                  default: "", null: false
  end

  create_table "urls", force: :cascade do |t|
    t.integer "season_id", null: false
    t.string  "url"
  end

end
