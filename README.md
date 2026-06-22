# NUBB Stats

Northwestern University basketball stats site tracking all players since the 2022–23 season. Built for personal use by Connor and a few friends.

## Stack

- **Ruby on Rails 8.1.3** — server-rendered HTML, no JS framework
- **PostgreSQL** — local only (Heroku removed)

---

## Updating Stats Locally

After any NU game, run this to pull in new data, then start the server to see it:

```bash
rails import:stats
rails server
```

Safe to run as many times as you want — all upserts, no duplicates. Auto-detects the current season by date.

**Before the first import of a new season**, make sure `db/seeds.rb` is up to date with all players on the roster (including new players) and their class years for that season, then re-run:

```bash
rails db:seed
```

The importer won't associate stats correctly with players who aren't in the seed data. When the new roster is announced each fall, update seeds first, then import.

---

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
