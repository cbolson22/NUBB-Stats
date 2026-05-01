class Game < ApplicationRecord
  belongs_to :season
  has_many :player_game_stats, dependent: :destroy
  has_many :players, through: :player_game_stats

  validates :api_game_id, presence: true, uniqueness: true
  validates :date, :opponent, :home_away, :season_type, presence: true
end
