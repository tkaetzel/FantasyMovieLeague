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

ActiveRecord::Schema.define(version: 20140122025315) do

  create_table "earnings", force: true do |t|
    t.integer  "movie_id"
    t.integer  "gross"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", force: true do |t|
    t.string   "name"
    t.string   "mapped_name"
    t.text     "plot"
    t.string   "actors"
    t.datetime "release_date"
    t.string   "imdb"
  end

  create_table "players", force: true do |t|
    t.string   "long_name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players_teams", id: false, force: true do |t|
    t.integer "player_id", null: false
    t.integer "team_id",   null: false
  end

  create_table "shares", force: true do |t|
    t.integer "player_id"
    t.integer "movie_id"
    t.integer "num_shares"
  end

  create_table "teams", force: true do |t|
    t.string "name"
  end

end
