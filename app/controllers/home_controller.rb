class HomeController < ApplicationController
  def index
    current_year  = Season.maximum(:year)
    @season_year  = current_year

    games = Game.joins(:season).where(seasons: { year: current_year })
    @wins         = games.where(result: "W").count
    @losses       = games.where(result: "L").count
    conf_games    = games.where(conference_game: true, season_type: "regular")
                        .where("games.notes IS NULL OR games.notes NOT LIKE ?", "Big Ten Tournament%")
    @conf_wins    = conf_games.where(result: "W").count
    @conf_losses  = conf_games.where(result: "L").count
    @recent_games = games.where.not(result: nil).order(date: :desc).limit(5).to_a

    raw_stats     = PlayerGameStat.for_season(current_year)
                                  .aggregated_stats
                                  .with_min_games(3)
    players_by_id = Player.where(id: raw_stats.map(&:player_id)).index_by(&:id)

    @ppg_leader   = PlayerGameStat.leader_for(raw_stats, players_by_id, "ppg")
    @rpg_leader   = PlayerGameStat.leader_for(raw_stats, players_by_id, "rpg")
    @apg_leader   = PlayerGameStat.leader_for(raw_stats, players_by_id, "apg")
    @player_count = Player.count

    @tournament_runs = Game.joins(:season)
                           .where(tournament: "NCAA")
                           .order("seasons.year ASC, games.date ASC")
                           .includes(:season)
                           .group_by(&:season)
                           .sort_by { |season, _| season.year }
  end
end
