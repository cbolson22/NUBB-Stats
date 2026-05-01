class Player < ApplicationRecord
  has_many :player_seasons, dependent: :destroy
  has_many :seasons, through: :player_seasons
  has_many :player_game_stats, dependent: :destroy
  has_many :games, through: :player_game_stats

  validates :name, presence: true
  validates :api_athlete_id, presence: true, uniqueness: true
end
