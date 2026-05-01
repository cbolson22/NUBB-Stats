namespace :import do
  desc "Import current season stats from the collegebasketballdata.com API"
  task stats: :environment do
    current_season = Date.today.month >= 10 ? Date.today.year + 1 : Date.today.year
    Rails.logger.info "Running stats import for season #{current_season}"
    StatsImporter.import(season: current_season)
    Rails.logger.info "Stats import complete"
  end
end
