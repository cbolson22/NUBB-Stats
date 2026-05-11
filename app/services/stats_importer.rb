require "net/http"
require "json"

class StatsImporter
  API_BASE = "https://api.collegebasketballdata.com"
  TEAM = "Northwestern"
  NU_TEAM_ID = 212

  def self.import(season:, use_fixture: false)
    new(season:, use_fixture:).import
  end

  def initialize(season:, use_fixture: false)
    @season = season
    @use_fixture = use_fixture
  end

  def import
    ActiveRecord::Base.transaction do
      season_record = Season.find_or_create_by!(year: @season)
      games_data = fetch_games
      players_data = fetch_players

      games_by_id = index_games_by_id(games_data)

      players_data.each do |game_entry|
        next unless games_by_id.dig(game_entry["gameId"], "status") == "final"
        game_id = game_entry["gameId"]
        game_info = games_by_id[game_id]
        next unless game_info

        game = upsert_game(game_entry, game_info, season_record)
        game_entry["players"].each do |player_data|
          player = upsert_player(player_data)
          upsert_player_game_stat(player, game, player_data)
        end
      end
    end

    Rails.logger.info "Import complete for #{TEAM} season #{@season}"
  end

  private

  def fetch_games
    if @use_fixture
      JSON.parse(File.read(Rails.root.join("test/fixtures/files/nu_games_#{@season}.json")))
    else
      get("/games?team=#{CGI.escape(TEAM)}&season=#{@season}")
    end
  end

  def fetch_players
    if @use_fixture
      JSON.parse(File.read(Rails.root.join("test/fixtures/files/nu_players_#{@season}.json")))
    else
      get("/games/players?team=#{CGI.escape(TEAM)}&season=#{@season}")
    end
  end

  def get(path)
    uri = URI("#{API_BASE}#{path}")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{ENV.fetch("CBBD_API_KEY")}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    raise "API error #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end

  def index_games_by_id(games_data)
    games_data.index_by { |g| g["id"] }
  end

  def upsert_game(game_entry, game_info, season_record)
    nu_home = game_info["homeTeamId"] == NU_TEAM_ID
    neutral = game_info["neutralSite"]

    home_away = if neutral then "neutral"
    elsif nu_home then "home"
    else "away"
    end

    nu_score  = nu_home ? game_info["homePoints"] : game_info["awayPoints"]
    opp_score = nu_home ? game_info["awayPoints"] : game_info["homePoints"]
    result    = nu_score && opp_score ? (nu_score > opp_score ? "W" : "L") : nil
    opponent  = nu_home ? game_info["awayTeam"] : game_info["homeTeam"]
    opp_id    = nu_home ? game_info["awayTeamId"] : game_info["homeTeamId"]

    game = Game.find_or_initialize_by(api_game_id: game_info["id"])
    game.assign_attributes(
      season: season_record,
      date: game_entry["startDate"],
      opponent: opponent,
      opponent_api_id: opp_id,
      home_away: home_away,
      nu_score: nu_score,
      opp_score: opp_score,
      result: result,
      season_type: game_entry["seasonType"],
      conference_game: game_entry["conferenceGame"],
      tournament: game_entry["tournament"],
      notes: game_entry["notes"],
      nu_seed: game_entry["teamSeed"],
      opponent_seed: game_entry["opponentSeed"],
      attendance: game_info["attendance"],
      venue: game_info["venue"]
    )
    game.save!
    game
  end

  def upsert_player(player_data)
    player = Player.find_or_initialize_by(api_athlete_id: player_data["athleteSourceId"])
    player.name = player_data["name"]
    player.save!
    player
  end

  def upsert_player_game_stat(player, game, player_data)
    stat = PlayerGameStat.find_or_initialize_by(player: player, game: game)
    stat.assign_attributes(
      starter: player_data["starter"],
      minutes: player_data["minutes"],
      points: player_data["points"],
      reb_offensive: player_data.dig("rebounds", "offensive"),
      reb_defensive: player_data.dig("rebounds", "defensive"),
      reb_total: player_data.dig("rebounds", "total"),
      assists: player_data["assists"],
      steals: player_data["steals"],
      blocks: player_data["blocks"],
      turnovers: player_data["turnovers"],
      fouls: player_data["fouls"],
      fgm: player_data.dig("fieldGoals", "made"),
      fga: player_data.dig("fieldGoals", "attempted"),
      fg3m: player_data.dig("threePointFieldGoals", "made"),
      fg3a: player_data.dig("threePointFieldGoals", "attempted"),
      ftm: player_data.dig("freeThrows", "made"),
      fta: player_data.dig("freeThrows", "attempted"),
      game_score: player_data["gameScore"],
      offensive_rating: player_data["offensiveRating"],
      defensive_rating: player_data["defensiveRating"],
      usage: player_data["usage"]
    )
    stat.save!
  end
end
