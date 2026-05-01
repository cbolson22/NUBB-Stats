class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.integer :api_game_id, null: false
      t.references :season, null: false, foreign_key: { on_delete: :cascade }
      t.datetime :date, null: false
      t.string :opponent, null: false
      t.integer :opponent_api_id
      t.string :home_away, null: false
      t.integer :nu_score
      t.integer :opp_score
      t.string :result
      t.string :season_type, null: false
      t.boolean :conference_game, null: false, default: false
      t.string :tournament
      t.integer :attendance
      t.string :venue

      t.timestamps
    end

    add_index :games, :api_game_id, unique: true
    add_index :games, :date
  end
end
