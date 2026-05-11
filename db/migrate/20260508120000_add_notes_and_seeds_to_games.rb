class AddNotesAndSeedsToGames < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :notes, :text
    add_column :games, :nu_seed, :integer
    add_column :games, :opponent_seed, :integer
  end
end
