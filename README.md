# BarKeep

A home bar inventory tracker. Built with Rails, runs in Docker.

[![GHCR](https://img.shields.io/github/v/release/nckslvrmn/bar_keep?label=GHCR&logo=github&color=blue)](https://github.com/nckslvrmn/bar_keep/pkgs/container/bar_keep) [![License](https://img.shields.io/github/license/nckslvrmn/bar_keep)](LICENSE)

## What it does

- Track bottles, ingredients, and supplies with quantities and images
- Categorize items (spirits, mixers, syrups, etc.)
- Low stock and out-of-stock alerts
- Filter and search across your inventory
- Multi-user with admin, regular, and read-only guest accounts
- Dark/light theme, works on mobile

## Running with Docker

```bash
# Generate a secret key
docker run --rm ghcr.io/nckslvrmn/bar_keep:latest rails secret

# Run it
docker run -d \
  --name barkeep \
  -p 3000:3000 \
  -v $(pwd)/storage:/app/storage \
  -e SECRET_KEY_BASE=<your-secret-key> \
  -e ALLOWED_HOST=barkeep.yourdomain.com \
  -e FORCE_SSL=false \
  ghcr.io/nckslvrmn/bar_keep:latest
```

The database is created and migrated automatically on first boot.

### Docker Compose

See [`compose.yml`](compose.yml) in the repo for an example. Set your env vars and run:

```bash
docker compose up -d
```

### Environment variables

| Variable | Required | Description |
|---|---|---|
| `SECRET_KEY_BASE` | Yes | Generate with `rails secret` |
| `ALLOWED_HOST` | No | Hostname for production (default: localhost) |
| `FORCE_SSL` | No | Set `false` if behind a reverse proxy (default: true) |
| `RAILS_ENV` | No | Default: production |

### Image tags

- `latest` — most recent release
- `vX.Y.Z` — pinned version

## Development

Requires Ruby 4.0+ and SQLite3.

```bash
bundle install
rails db:setup
rails server
```

### Running checks

```bash
bin/rubocop          # lint
bin/brakeman         # security scan
bin/rails test       # tests
```

### Default login

After `db:seed`:
- Username: `admin`
- Password: `changeme123`

Change this after first login.

## Data

Everything lives in `./storage` — SQLite databases, uploaded images, session data. Back this up and mount the same volume when updating containers.

