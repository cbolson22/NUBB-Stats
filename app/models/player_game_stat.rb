class PlayerGameStat < ApplicationRecord
  belongs_to :player
  belongs_to :game

  validates :player_id, uniqueness: { scope: :game_id }

  scope :for_season, ->(year) {
    year.present? ? joins(:game).where(games: { season_id: Season.find_by(year: year)&.id }) : joins(:game)
  }
  scope :for_class_year, ->(class_year, season_year) {
    if season_year.present?
      season = Season.find_by(year: season_year)
      joins(player: :player_seasons).where(player_seasons: { class_year: class_year, season_id: season&.id })
    else
      joins("INNER JOIN player_seasons ON player_seasons.player_id = player_game_stats.player_id AND player_seasons.season_id = games.season_id")
        .where(player_seasons: { class_year: class_year })
    end
  }
  scope :with_minutes, -> { where("minutes > 0") }

  def self.aggregated_stats
    select(
      "player_id",
      "COUNT(*) AS games_played",
      "SUM(points) AS total_pts",
      "SUM(reb_total) AS total_reb",
      "SUM(assists) AS total_ast",
      "SUM(steals) AS total_stl",
      "SUM(blocks) AS total_blk",
      "SUM(turnovers) AS total_to",
      "SUM(fgm) AS total_fgm",
      "SUM(fga) AS total_fga",
      "SUM(fg3m) AS total_fg3m",
      "SUM(fg3a) AS total_fg3a",
      "SUM(ftm) AS total_ftm",
      "SUM(fta) AS total_fta",
      "SUM(minutes) AS total_min",
      "ROUND(AVG(points)::numeric, 1) AS ppg",
      "ROUND(AVG(reb_total)::numeric, 1) AS rpg",
      "ROUND(AVG(assists)::numeric, 1) AS apg",
      "ROUND(AVG(steals)::numeric, 1) AS spg",
      "ROUND(AVG(blocks)::numeric, 1) AS bpg",
      "ROUND(AVG(turnovers)::numeric, 1) AS topg",
      "ROUND(AVG(minutes)::numeric, 1) AS mpg",
      "ROUND(AVG(fgm)::numeric, 1) AS fgm_pg",
      "ROUND(AVG(fga)::numeric, 1) AS fga_pg",
      "ROUND(AVG(fg3m)::numeric, 1) AS fg3m_pg",
      "ROUND(AVG(fg3a)::numeric, 1) AS fg3a_pg",
      "ROUND(AVG(ftm)::numeric, 1) AS ftm_pg",
      "ROUND(AVG(fta)::numeric, 1) AS fta_pg",
      "ROUND(CASE WHEN SUM(fga) > 0 THEN SUM(fgm)::numeric / SUM(fga) * 100 ELSE 0 END, 1) AS fg_pct",
      "ROUND(CASE WHEN SUM(fg3a) > 0 THEN SUM(fg3m)::numeric / SUM(fg3a) * 100 ELSE 0 END, 1) AS fg3_pct",
      "ROUND(CASE WHEN SUM(fta) > 0 THEN SUM(ftm)::numeric / SUM(fta) * 100 ELSE 0 END, 1) AS ft_pct"
    ).group(:player_id)
  end
end
