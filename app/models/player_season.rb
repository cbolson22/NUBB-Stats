class PlayerSeason < ApplicationRecord
  CLASS_YEARS = %w[freshman sophomore junior senior graduate].freeze
  belongs_to :player
  belongs_to :season

  validates :class_year, presence: true
  validates :player_id, uniqueness: { scope: :season_id }
end
