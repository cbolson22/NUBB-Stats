class PlayersController < ApplicationController
  SORTABLE_COLS = %w[
    games_played total_pts total_reb total_ast total_stl total_blk total_to
    total_fgm total_fga fg_pct total_fg3m total_fg3a fg3_pct total_ftm total_fta ft_pct
    ppg rpg apg spg bpg topg
    fgm_pg fga_pg fg3m_pg fg3a_pg ftm_pg fta_pg
  ].freeze

  def index
    season_year = params[:season].presence && params[:season] != "all" ? params[:season].to_i : nil
    class_year  = params[:class_year].presence
    per_game    = params[:mode] == "per_game"

    default_sort = per_game ? "ppg" : "total_pts"
    @sort_col    = SORTABLE_COLS.include?(params[:sort]) ? params[:sort] : default_sort
    @sort_dir    = params[:dir] == "asc" ? "asc" : "desc"

    stats = PlayerGameStat.for_season(season_year)
    stats = stats.for_class_year(class_year, season_year) if class_year
    stats = stats.aggregated_stats.order(Arel.sql("#{@sort_col} #{@sort_dir} NULLS LAST"))

    players_by_id = Player.where(id: stats.map(&:player_id)).index_by(&:id)

    @season_year = season_year
    @seasons     = Season.order(year: :desc).pluck(:year)
    @class_years = PlayerSeason::CLASS_YEARS
    @stats       = stats.map do |s|
      player = players_by_id[s.player_id]
      next unless player
      { player: player, stats: s, class_year: player.class_year_for(season_year) }
    end.compact
  end

  def show
    @player      = Player.find(params[:id])
    @seasons     = @player.seasons.order(year: :desc).pluck(:year)
    season_year  = params[:season] ? params[:season].to_i : @seasons.first
    @season_year = season_year
    @game_stats  = @player.player_game_stats
                          .for_season(season_year)
                          .joins(:game)
                          .order("games.date ASC")
                          .includes(:game)
  end
end
