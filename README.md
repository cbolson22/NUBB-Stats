# NUBB Stats

Northwestern University basketball stats site tracking all players since the 2022–23 season. Built for personal use by Connor and a few friends.

## Stack

- **Ruby on Rails 8.1.3** — server-rendered HTML, no JS framework
- **PostgreSQL** — hosted on Heroku Postgres (essential-0)
- **Heroku** — app name `nubb-stats`, auto-deploy from GitHub main branch
- **Heroku Scheduler** — runs `rake import:stats` nightly at 2am UTC

## Data Source

[collegebasketballdata.com](https://collegebasketballdata.com/) — free tier, 1000 requests/month. API key stored in Heroku config vars (`CBBD_API_KEY`) and locally in `.env`.

Season numbering: `season=2023` means the 2022–23 season (ending year).

## Local Development

```bash
bundle install
rails db:create db:migrate db:seed
rails server
```

The stats importer uses fixture files locally to avoid hitting the API rate limit. Fixture JSON files are in `test/fixtures/files/`.

To run the importer locally against fixtures:
```ruby
StatsImporter.import(season: 2026, use_fixture: true)
```

## Running Tests

```bash
rake ci
```

## Importing Stats

```bash
# Heroku
heroku run rake import:stats --app nubb-stats

# Local (uses fixture files)
rake import:stats
```

## Deployment

Push to `main` — Heroku auto-deploys. After schema changes:

```bash
heroku run rails db:migrate --app nubb-stats
```
