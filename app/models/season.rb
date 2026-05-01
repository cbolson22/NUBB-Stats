class Season < ApplicationRecord
  has_many :games, dependent: :destroy
  has_many :player_seasons, dependent: :destroy
  has_many :players, through: :player_seasons

  validates :year, presence: true, uniqueness: true
end
