class CreatePlayerSeasons < ActiveRecord::Migration[8.1]
  def change
    create_table :player_seasons do |t|
      t.references :player, null: false, foreign_key: { on_delete: :cascade }
      t.references :season, null: false, foreign_key: { on_delete: :cascade }
      t.string :class_year, null: false

      t.timestamps
    end

    add_index :player_seasons, [:player_id, :season_id], unique: true
  end
end
