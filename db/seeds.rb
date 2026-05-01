# Idempotent seed file — safe to run multiple times.
# Update class_year each season. Add new players as they join the roster.
# class_year values: freshman, sophomore, junior, senior, graduate

PLAYER_SEASONS = [
  # 2022-23 season (API season: 2023)
  { api_source_id: "4592712", name: "Boo Buie",          season: 2023, class_year: "senior" },
  { api_source_id: "4684208", name: "Brooks Barnhizer",  season: 2023, class_year: "sophomore" },
  { api_source_id: "4397602", name: "Chase Audige",      season: 2023, class_year: "senior" },
  { api_source_id: "4683949", name: "Julian Roper II",   season: 2023, class_year: "sophomore" },
  { api_source_id: "5105833", name: "Luke Hunger",       season: 2023, class_year: "freshman" },
  { api_source_id: "4702289", name: "Matthew Nicholson", season: 2023, class_year: "junior" },
  { api_source_id: "5105832", name: "Nick Martinelli",   season: 2023, class_year: "freshman" },
  { api_source_id: "4431737", name: "Robbie Beran",      season: 2023, class_year: "senior" },
  { api_source_id: "4592715", name: "Roy Dixon III",     season: 2023, class_year: "senior" },
  { api_source_id: "4702288", name: "Ty Berry",          season: 2023, class_year: "junior" },
  { api_source_id: "4278488", name: "Tydus Verhoeven",   season: 2023, class_year: "graduate" },
  { api_source_id: "5105834", name: "Blake Smith",       season: 2023, class_year: "freshman" },
  { api_source_id: "5105835", name: "Gus Hurlburt",      season: 2023, class_year: "freshman" },

  # 2023-24 season (API season: 2024)
  { api_source_id: "4396747", name: "Blake Preston",     season: 2024, class_year: "graduate" },
  { api_source_id: "5105834", name: "Blake Smith",       season: 2024, class_year: "sophomore" },
  { api_source_id: "4592712", name: "Boo Buie",          season: 2024, class_year: "graduate" },
  { api_source_id: "4684208", name: "Brooks Barnhizer",  season: 2024, class_year: "junior" },
  { api_source_id: "5105835", name: "Gus Hurlburt",      season: 2024, class_year: "sophomore" },
  { api_source_id: "5093250", name: "Jordan Clayton",    season: 2024, class_year: "freshman" },
  { api_source_id: "5107289", name: "Justin Mullins",    season: 2024, class_year: "sophomore" },
  { api_source_id: "5105833", name: "Luke Hunger",       season: 2024, class_year: "sophomore" },
  { api_source_id: "4702289", name: "Matthew Nicholson", season: 2024, class_year: "senior" },
  { api_source_id: "5105832", name: "Nick Martinelli",   season: 2024, class_year: "sophomore" },
  { api_source_id: "4597863", name: "Ryan Langborg",     season: 2024, class_year: "graduate" },
  { api_source_id: "4702288", name: "Ty Berry",          season: 2024, class_year: "senior" },
  { api_source_id: "5174800", name: "Blake Barkley",     season: 2024, class_year: "freshman" },
  { api_source_id: "5174801", name: "Parker Strauss",    season: 2024, class_year: "freshman" },

  # 2024-25 season (API season: 2025)
  { api_source_id: "5239575", name: "Angelo Ciaravino",  season: 2025, class_year: "freshman" },
  { api_source_id: "5174800", name: "Blake Barkley",     season: 2025, class_year: "freshman" },
  { api_source_id: "5105834", name: "Blake Smith",       season: 2025, class_year: "junior" },
  { api_source_id: "4684208", name: "Brooks Barnhizer",  season: 2025, class_year: "senior" },
  { api_source_id: "5105835", name: "Gus Hurlburt",      season: 2025, class_year: "sophomore" },
  { api_source_id: "4702945", name: "Jalen Leach",       season: 2025, class_year: "graduate" },
  { api_source_id: "5093250", name: "Jordan Clayton",    season: 2025, class_year: "sophomore" },
  { api_source_id: "5107289", name: "Justin Mullins",    season: 2025, class_year: "junior" },
  { api_source_id: "5101650", name: "K.J. Windham",      season: 2025, class_year: "freshman" },
  { api_source_id: "4397113", name: "Keenan Fitzmorris", season: 2025, class_year: "graduate" },
  { api_source_id: "5105833", name: "Luke Hunger",       season: 2025, class_year: "sophomore" },
  { api_source_id: "4702289", name: "Matthew Nicholson", season: 2025, class_year: "graduate" },
  { api_source_id: "5105832", name: "Nick Martinelli",   season: 2025, class_year: "junior" },
  { api_source_id: "4702288", name: "Ty Berry",          season: 2025, class_year: "graduate" },

  # 2025-26 season (API season: 2026)
  { api_source_id: "5239575", name: "Angelo Ciaravino",  season: 2026, class_year: "sophomore" },
  { api_source_id: "5060696", name: "Arrinten Page",     season: 2026, class_year: "junior" },
  { api_source_id: "5105835", name: "Gus Hurlburt",      season: 2026, class_year: "junior" },
  { api_source_id: "5221322", name: "Jake West",         season: 2026, class_year: "freshman" },
  { api_source_id: "4895746", name: "Jayden Reid",       season: 2026, class_year: "junior" },
  { api_source_id: "5093250", name: "Jordan Clayton",    season: 2026, class_year: "junior" },
  { api_source_id: "5107289", name: "Justin Mullins",    season: 2026, class_year: "senior" },
  { api_source_id: "5101650", name: "K.J. Windham",      season: 2026, class_year: "sophomore" },
  { api_source_id: "5242943", name: "Max Green",         season: 2026, class_year: "sophomore" },
  { api_source_id: "5105832", name: "Nick Martinelli",   season: 2026, class_year: "senior" },
  { api_source_id: "5254158", name: "Phoenix Gill",      season: 2026, class_year: "freshman" },
  { api_source_id: "5226071", name: "Tre Singleton",     season: 2026, class_year: "freshman" },
  { api_source_id: "5144141", name: "Tyler Kropp",       season: 2026, class_year: "freshman" },
  { api_source_id: "5196943", name: "Cade Bennerman",    season: 2026, class_year: "freshman" },
  { api_source_id: "5105834", name: "Blake Smith",       season: 2026, class_year: "senior" }
].freeze

PLAYER_SEASONS.each do |entry|
  season = Season.find_or_create_by!(year: entry[:season])
  player = Player.find_or_create_by!(api_athlete_id: entry[:api_source_id]) do |p|
    p.name = entry[:name]
  end
  PlayerSeason.find_or_create_by!(player: player, season: season) do |ps|
    ps.class_year = entry[:class_year]
  end
end
