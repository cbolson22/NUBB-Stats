class Game < ApplicationRecord
  belongs_to :season
  has_many :player_game_stats, dependent: :destroy
  has_many :players, through: :player_game_stats

  validates :api_game_id, presence: true, uniqueness: true
  validates :date, :opponent, :home_away, :season_type, presence: true

  def game_category
    return "march_madness"      if tournament == "NCAA"
    return "big_ten_tournament" if notes&.start_with?("Big Ten Tournament")
    return "conference"         if conference_game?
    "nonconference"
  end

  def game_label
    case game_category
    when "march_madness"      then "(March Madness)"
    when "big_ten_tournament" then "(Big Ten Tournament)"
    when "conference"         then "(Big Ten)"
    else ""
    end
  end
end
