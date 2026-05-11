class PlayersController < ApplicationController
  GAME_SORTABLE_COLS = %w[date minutes points reb_total assists steals blocks turnovers fgm fg3m ftm].freeze

  SORTABLE_COLS = %w[
    games_played total_pts total_reb total_ast total_stl total_blk total_to
    total_fgm total_fga fg_pct total_fg3m total_fg3a fg3_pct total_ftm total_fta ft_pct
    ppg rpg apg spg bpg topg
    fgm_pg fga_pg fg3m_pg fg3a_pg ftm_pg fta_pg
  ].freeze

  VALID_GAME_TYPES = %w[conference nonconference big_ten_tournament march_madness].freeze

  def index
    per_game     = params[:mode] == "per_game"
    default_sort = per_game ? "ppg" : "total_pts"
    @sort_col    = SORTABLE_COLS.include?(params[:sort]) ? params[:sort] : default_sort
    @sort_dir    = params[:dir] == "asc" ? "asc" : "desc"

    @selected_seasons     = Array(params[:seasons]).map(&:to_i).select { |y| y > 0 }
    @selected_class_years = Array(params[:class_years]).reject(&:blank?)
    @selected_game_types  = Array(params[:game_types]).select { |t| VALID_GAME_TYPES.include?(t) }
    @start_date           = params[:start_date].presence
    @end_date             = params[:end_date].presence

    @stat_filters = PlayerGameStat::STAT_FILTER_EXPRS.keys.each_with_object({}) do |key, h|
      min_val = params["#{key}_min"].presence
      max_val = params["#{key}_max"].presence
      h[key] = { min: min_val, max: max_val } if min_val || max_val
    end

    stats = PlayerGameStat
              .for_season(@selected_seasons.presence)
              .for_class_year(@selected_class_years)
              .for_game_types(@selected_game_types)
              .for_date_range(@start_date, @end_date)
              .aggregated_stats(@stat_filters)
              .order(Arel.sql("#{@sort_col} #{@sort_dir} NULLS LAST"))

    players_by_id = Player.where(id: stats.map(&:player_id)).index_by(&:id)

    @seasons     = Season.order(year: :desc).pluck(:year)
    @class_years = PlayerSeason::CLASS_YEARS

    display_season = @selected_seasons.one? ? @selected_seasons.first : nil
    @stats = stats.map do |s|
      player = players_by_id[s.player_id]
      next unless player
      { player: player, stats: s, class_year: player.class_year_for(display_season) }
    end.compact
  end

  def show
    @player      = Player.find(params[:id])
    @seasons     = @player.seasons.order(year: :desc).pluck(:year)
    season_year  = if params[:season] == "all"
                     nil
    elsif params[:season]
                     params[:season].to_i
    else
                     @seasons.first
    end
    @season_year = season_year
    @sort_col    = GAME_SORTABLE_COLS.include?(params[:sort]) ? params[:sort] : "date"
    default_dir  = @sort_col == "date" ? "asc" : "desc"
    @sort_dir    = %w[asc desc].include?(params[:dir]) ? params[:dir] : default_dir
    order_sql    = @sort_col == "date" ? "games.date #{@sort_dir}" : "player_game_stats.#{@sort_col} #{@sort_dir} NULLS LAST"

    @game_stats  = @player.player_game_stats
                          .for_season(season_year)
                          .order(Arel.sql(order_sql))
                          .includes(game: :season)
  end
end
