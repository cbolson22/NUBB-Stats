class CreatePlayerGameStats < ActiveRecord::Migration[8.1]
  def change
    create_table :player_game_stats do |t|
      t.references :player, null: false, foreign_key: { on_delete: :cascade }
      t.references :game, null: false, foreign_key: { on_delete: :cascade }
      t.boolean :starter, null: false, default: false
      t.integer :minutes
      t.integer :points
      t.integer :reb_offensive
      t.integer :reb_defensive
      t.integer :reb_total
      t.integer :assists
      t.integer :steals
      t.integer :blocks
      t.integer :turnovers
      t.integer :fouls
      t.integer :fgm
      t.integer :fga
      t.integer :fg3m
      t.integer :fg3a
      t.integer :ftm
      t.integer :fta
      t.float :game_score
      t.float :offensive_rating
      t.float :defensive_rating
      t.float :usage

      t.timestamps
    end

    add_index :player_game_stats, [ :player_id, :game_id ], unique: true
  end
end
