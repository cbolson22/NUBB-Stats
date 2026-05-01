require "test_helper"

class PlayerGameStatTest < ActiveSupport::TestCase
  # for_season

  test "for_season with a year returns only that season's stats" do
    stats = PlayerGameStat.for_season(2024)
    # boo x2, chase x2 — boo's 2025 game excluded
    assert_equal 4, stats.count
  end

  test "for_season with nil returns all stats across all seasons" do
    stats = PlayerGameStat.for_season(nil)
    # boo x3, chase x2
    assert_equal 5, stats.count
  end

  # for_class_year with a specific season

  test "for_class_year with season returns stats for players matching that class year in that season" do
    stats = PlayerGameStat.for_season(2024).for_class_year("senior", 2024)
    # only boo was a senior in 2024 — 2 games
    assert_equal 2, stats.count
    assert stats.all? { |s| s.player_id == players(:boo).id }
  end

  test "for_class_year with season excludes players who are a different class year" do
    stats = PlayerGameStat.for_season(2024).for_class_year("graduate", 2024)
    assert_equal 0, stats.count
  end

  # for_class_year cross-season (season_year nil)

  test "for_class_year cross-season returns each player's stats only from the season they held that class year" do
    stats = PlayerGameStat.for_season(nil).for_class_year("senior", nil)
    # boo was a senior in 2024 (2 games) — his 2025 graduate season excluded
    assert_equal 2, stats.count
    assert stats.all? { |s| s.player_id == players(:boo).id }
  end

  test "for_class_year cross-season excludes games from a season where the player had a different class year" do
    stats = PlayerGameStat.for_season(nil).for_class_year("graduate", nil)
    # boo was a graduate in 2025 (1 game)
    assert_equal 1, stats.count
  end

  # aggregated_stats

  test "aggregated_stats groups by player and sums correctly" do
    result = PlayerGameStat.for_season(2024).aggregated_stats
    boo_row = result.find { |r| r.player_id == players(:boo).id }

    assert_equal 2,  boo_row.games_played.to_i
    assert_equal 30, boo_row.total_pts.to_i   # 20 + 10
    assert_equal 11, boo_row.total_fgm.to_i   # 7 + 4
    assert_equal 27, boo_row.total_fga.to_i   # 15 + 12
  end

  test "aggregated_stats calculates per game averages correctly" do
    result = PlayerGameStat.for_season(2024).aggregated_stats
    boo_row = result.find { |r| r.player_id == players(:boo).id }

    assert_equal 15.0, boo_row.ppg.to_f   # 30 pts / 2 games
  end

  test "aggregated_stats calculates fg_pct correctly" do
    result = PlayerGameStat.for_season(2024).aggregated_stats
    boo_row = result.find { |r| r.player_id == players(:boo).id }

    # 11 FGM / 27 FGA * 100 = 40.7%
    assert_in_delta 40.7, boo_row.fg_pct.to_f, 0.1
  end

  test "aggregated_stats returns one row per player" do
    result = PlayerGameStat.for_season(2024).aggregated_stats
    assert_equal 2, result.length  # boo and chase
  end
end
