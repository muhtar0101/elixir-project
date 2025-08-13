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


# Жинақты тоқтату/тазалау

docker compose down -v

# Қайта құру (код өзгерді)

docker compose build --no-cache web

# DB ғана көтеріп алу

docker compose up -d db

# Тәуелділіктерді компиляциялау + миграциялар + сидтер

docker compose run --rm web bash -lc "mix deps.get && mix deps.compile && mix ecto.setup && mix run priv/repo/seeds.exs"

# Енді web-ті көтереміз

docker compose up -d web

# Логтарды қарау

docker compose logs -f web
