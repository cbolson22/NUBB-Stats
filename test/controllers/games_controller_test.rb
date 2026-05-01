require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "index returns 200" do
    get games_path
    assert_response :success
  end

  test "index with a season param returns 200" do
    get games_path(season: 2024)
    assert_response :success
  end

  test "index loads only games for the selected season" do
    get games_path(season: 2024)
    assert_equal 2, controller.instance_variable_get(:@games).count
  end

  test "index defaults to the most recent season" do
    get games_path
    assert_equal 2025, controller.instance_variable_get(:@season_year)
  end
end
