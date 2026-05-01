require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  # index

  test "index returns 200" do
    get players_path
    assert_response :success
  end

  test "index with a season filter returns 200" do
    get players_path(season: 2024)
    assert_response :success
  end

  test "index with a class year filter returns 200" do
    get players_path(season: 2024, class_year: "senior")
    assert_response :success
  end

  test "index in per game mode returns 200" do
    get players_path(mode: "per_game")
    assert_response :success
  end

  test "index with a valid sort param returns 200" do
    get players_path(sort: "total_pts", dir: "asc")
    assert_response :success
  end

  test "index with an invalid sort param is safely ignored and returns 200" do
    get players_path(sort: "DROP TABLE players", dir: "invalid")
    assert_response :success
  end

  test "index with all seasons and class year filter returns 200" do
    get players_path(class_year: "senior")
    assert_response :success
  end

  # show

  test "show returns 200" do
    get player_path(players(:boo))
    assert_response :success
  end

  test "show with a season param returns 200" do
    get player_path(players(:boo), season: 2024)
    assert_response :success
  end

  test "show defaults to player's most recent season when no season param is given" do
    get player_path(players(:boo))
    # boo's most recent season is 2025, so @season_year should be 2025
    assert_equal 2025, controller.instance_variable_get(:@season_year)
  end

  test "show for a player with no game stats returns 200" do
    get player_path(players(:parker))
    assert_response :success
  end
end
