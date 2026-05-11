class GamesController < ApplicationController
  def index
    season_year  = params[:season] ? params[:season].to_i : Season.maximum(:year)
    @season_year = season_year
    @seasons     = Season.order(year: :desc).pluck(:year)
    @games       = Game.joins(:season)
                       .where(seasons: { year: season_year })
                       .order(date: :asc)
                       .includes(player_game_stats: :player)
    @wins        = @games.where(result: "W").count
    @losses      = @games.where(result: "L").count

    conf_games   = @games.where(conference_game: true, season_type: "regular")
                         .where("games.notes IS NULL OR games.notes NOT LIKE ?", "Big Ten Tournament%")
    @conf_wins   = conf_games.where(result: "W").count
    @conf_losses = conf_games.where(result: "L").count
  end
end
