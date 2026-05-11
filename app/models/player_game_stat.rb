class PlayerGameStat < ApplicationRecord
  belongs_to :player
  belongs_to :game

  validates :player_id, uniqueness: { scope: :game_id }

  STAT_FILTER_EXPRS = {
    "games_played" => "COUNT(*)",
    "ppg"          => "ROUND(AVG(points)::numeric, 1)",
    "rpg"          => "ROUND(AVG(reb_total)::numeric, 1)",
    "apg"          => "ROUND(AVG(assists)::numeric, 1)",
    "spg"          => "ROUND(AVG(steals)::numeric, 1)",
    "bpg"          => "ROUND(AVG(blocks)::numeric, 1)",
    "topg"         => "ROUND(AVG(turnovers)::numeric, 1)",
    "fg_pct"       => "ROUND(CASE WHEN SUM(fga) > 0 THEN SUM(fgm)::numeric / SUM(fga) * 100 ELSE 0 END, 1)",
    "fg3_pct"      => "ROUND(CASE WHEN SUM(fg3a) > 0 THEN SUM(fg3m)::numeric / SUM(fg3a) * 100 ELSE 0 END, 1)",
    "ft_pct"       => "ROUND(CASE WHEN SUM(fta) > 0 THEN SUM(ftm)::numeric / SUM(fta) * 100 ELSE 0 END, 1)"
  }.freeze

  # Always joins games so downstream scopes can reference games.* columns.
  scope :for_season, ->(year_or_years) {
    years = Array(year_or_years).map { |y| y.to_i }.reject(&:zero?)
    if years.empty?
      joins(:game)
    else
      joins(:game).where(games: { season_id: Season.where(year: years).select(:id) })
    end
  }

  # Matches class year to the game's own season so multi-season aggregation stays accurate.
  scope :for_class_year, ->(class_year_or_years, _season_year = nil) {
    class_years = Array(class_year_or_years).reject(&:blank?)
    return all if class_years.empty?
    joins("INNER JOIN player_seasons ON player_seasons.player_id = player_game_stats.player_id AND player_seasons.season_id = games.season_id")
      .where(player_seasons: { class_year: class_years })
  }

  scope :for_game_types, ->(game_types) {
    types = Array(game_types).reject(&:blank?)
    return all if types.empty?
    conditions = []
    conditions << "games.tournament = 'NCAA'" if types.include?("march_madness")
    conditions << "(games.notes LIKE 'Big Ten Tournament%')" if types.include?("big_ten_tournament")
    conditions << "(games.conference_game = true AND (games.notes IS NULL OR games.notes NOT LIKE 'Big Ten Tournament%') AND games.season_type = 'regular')" if types.include?("conference")
    conditions << "(games.conference_game = false AND games.season_type = 'regular')" if types.include?("nonconference")
    where(conditions.join(" OR "))
  }

  scope :for_date_range, ->(start_date, end_date) {
    return all if start_date.blank? && end_date.blank?
    base = all
    base = base.where("DATE(games.date) >= ?", start_date) if start_date.present?
    base = base.where("DATE(games.date) <= ?", end_date) if end_date.present?
    base
  }

  scope :with_minutes, -> { where("minutes > 0") }
  scope :with_min_games, ->(n) { having("COUNT(*) >= ?", n) }

  def self.leader_for(stats, players_by_id, col)
    best = stats.max_by { |s| s.send(col).to_f }
    return nil unless best
    { stat: best, player: players_by_id[best.player_id] }
  end

  def self.aggregated_stats(stat_havings = {})
    base = select(
      "player_game_stats.player_id",
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
    ).group("player_game_stats.player_id")

    stat_havings.each do |key, range|
      sql_expr = STAT_FILTER_EXPRS[key]
      next unless sql_expr
      base = base.having("#{sql_expr} >= ?", range[:min].to_f) if range[:min].present?
      base = base.having("#{sql_expr} <= ?", range[:max].to_f) if range[:max].present?
    end

    base
  end
end
