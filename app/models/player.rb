class Player < ApplicationRecord
  has_many :player_seasons, dependent: :destroy
  has_many :seasons, through: :player_seasons
  has_many :player_game_stats, dependent: :destroy
  has_many :games, through: :player_game_stats

  validates :name, presence: true
  validates :api_athlete_id, presence: true, uniqueness: true

  def class_year_for(season_year)
    player_seasons.joins(:season).find_by(seasons: { year: season_year })&.class_year
  end
end
