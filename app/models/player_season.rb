class PlayerSeason < ApplicationRecord
  belongs_to :player
  belongs_to :season

  validates :class_year, presence: true
  validates :player_id, uniqueness: { scope: :season_id }
end
