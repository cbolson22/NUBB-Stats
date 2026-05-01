class CreatePlayers < ActiveRecord::Migration[8.1]
  def change
    create_table :players do |t|
      t.string :name, null: false
      t.integer :api_athlete_id, null: false
      t.string :image_url

      t.timestamps
    end

    add_index :players, :api_athlete_id, unique: true
  end
end
