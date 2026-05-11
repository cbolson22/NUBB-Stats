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

ActiveRecord::Schema[8.1].define(version: 2026_05_08_120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer "api_game_id", null: false
    t.integer "attendance"
    t.boolean "conference_game", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "date", null: false
    t.string "home_away", null: false
    t.text "notes"
    t.integer "nu_score"
    t.integer "nu_seed"
    t.integer "opp_score"
    t.string "opponent", null: false
    t.integer "opponent_api_id"
    t.integer "opponent_seed"
    t.string "result"
    t.bigint "season_id", null: false
    t.string "season_type", null: false
    t.string "tournament"
    t.datetime "updated_at", null: false
    t.string "venue"
    t.index ["api_game_id"], name: "index_games_on_api_game_id", unique: true
    t.index ["date"], name: "index_games_on_date"
    t.index ["season_id"], name: "index_games_on_season_id"
  end

  create_table "player_game_stats", force: :cascade do |t|
    t.integer "assists"
    t.integer "blocks"
    t.datetime "created_at", null: false
    t.float "defensive_rating"
    t.integer "fg3a"
    t.integer "fg3m"
    t.integer "fga"
    t.integer "fgm"
    t.integer "fouls"
    t.integer "fta"
    t.integer "ftm"
    t.bigint "game_id", null: false
    t.float "game_score"
    t.integer "minutes"
    t.float "offensive_rating"
    t.bigint "player_id", null: false
    t.integer "points"
    t.integer "reb_defensive"
    t.integer "reb_offensive"
    t.integer "reb_total"
    t.boolean "starter", default: false, null: false
    t.integer "steals"
    t.integer "turnovers"
    t.datetime "updated_at", null: false
    t.float "usage"
    t.index ["game_id"], name: "index_player_game_stats_on_game_id"
    t.index ["player_id", "game_id"], name: "index_player_game_stats_on_player_id_and_game_id", unique: true
    t.index ["player_id"], name: "index_player_game_stats_on_player_id"
  end

  create_table "player_seasons", force: :cascade do |t|
    t.string "class_year", null: false
    t.datetime "created_at", null: false
    t.bigint "player_id", null: false
    t.bigint "season_id", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id", "season_id"], name: "index_player_seasons_on_player_id_and_season_id", unique: true
    t.index ["player_id"], name: "index_player_seasons_on_player_id"
    t.index ["season_id"], name: "index_player_seasons_on_season_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "api_athlete_id", null: false
    t.datetime "created_at", null: false
    t.string "image_url"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["api_athlete_id"], name: "index_players_on_api_athlete_id", unique: true
  end

  create_table "seasons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year", null: false
    t.index ["year"], name: "index_seasons_on_year", unique: true
  end

  add_foreign_key "games", "seasons", on_delete: :cascade
  add_foreign_key "player_game_stats", "games", on_delete: :cascade
  add_foreign_key "player_game_stats", "players", on_delete: :cascade
  add_foreign_key "player_seasons", "players", on_delete: :cascade
  add_foreign_key "player_seasons", "seasons", on_delete: :cascade
end
