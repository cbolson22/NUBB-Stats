class HomeController < ApplicationController
  def index
    current_year  = Season.maximum(:year)
    @season_year  = current_year

    games = Game.joins(:season).where(seasons: { year: current_year })
    @wins         = games.where(result: "W").count
    @losses       = games.where(result: "L").count
    @conf_wins    = games.where(result: "W", conference_game: true).count
    @conf_losses  = games.where(result: "L", conference_game: true).count
    @recent_games = games.where.not(result: nil).order(date: :desc).limit(5).to_a

    raw_stats     = PlayerGameStat.for_season(current_year)
                                  .aggregated_stats
                                  .with_min_games(3)
    players_by_id = Player.where(id: raw_stats.map(&:player_id)).index_by(&:id)

    @ppg_leader   = PlayerGameStat.leader_for(raw_stats, players_by_id, "ppg")
    @rpg_leader   = PlayerGameStat.leader_for(raw_stats, players_by_id, "rpg")
    @apg_leader   = PlayerGameStat.leader_for(raw_stats, players_by_id, "apg")
    @player_count = Player.count
  end
end
