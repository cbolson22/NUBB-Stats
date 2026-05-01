class GamesController < ApplicationController
  def index
    season_year  = params[:season] ? params[:season].to_i : Season.maximum(:year)
    @season_year = season_year
    @seasons     = Season.order(year: :desc).pluck(:year)
    @games       = Game.joins(:season)
                       .where(seasons: { year: season_year })
                       .order(date: :asc)
                       .includes(player_game_stats: :player)
  end
end
