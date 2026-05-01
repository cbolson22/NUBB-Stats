require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  test "class_year_for returns the correct class year for a given season" do
    assert_equal "senior",   players(:boo).class_year_for(2024)
    assert_equal "graduate", players(:boo).class_year_for(2025)
    assert_equal "junior",   players(:chase).class_year_for(2024)
  end

  test "class_year_for returns nil when the player has no entry for that season" do
    assert_nil players(:boo).class_year_for(2099)
    assert_nil players(:parker).class_year_for(2025)
  end

  test "player with no game stats is still a valid record" do
    assert players(:parker).valid?
    assert_equal 0, players(:parker).player_game_stats.count
  end
end
