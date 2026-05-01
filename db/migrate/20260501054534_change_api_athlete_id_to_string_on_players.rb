class ChangeApiAthleteIdToStringOnPlayers < ActiveRecord::Migration[8.1]
  def change
    change_column :players, :api_athlete_id, :string
  end
end
