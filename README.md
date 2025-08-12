## Run (Docker)

cp .env.example .env

# SECRET_KEY_BASE және LIVE_VIEW_SIGNING_SALT генерациялау

docker compose run --rm web mix phx.gen.secret
docker compose run --rm web mix phx.gen.secret

docker compose up -d

# бірінші рет

docker compose exec web mix ecto.create
docker compose exec web mix ecto.migrate
docker compose exec web mix run priv/repo/seeds.exs
