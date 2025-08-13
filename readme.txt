





# 0) (бірінші рет болса) репоны алыңыз
git clone https://github.com/muhtar0101/elixir-project
cd elixir-project

# 1) Билд
docker compose build

# 2) Базаны көтеру
docker compose up -d db

# 3) Тәуелділіктер
docker compose run --rm web mix deps.get

# 4) DB жасау + миграция
docker compose run --rm web mix ecto.create
docker compose run --rm web mix ecto.migrate

# 5) (қажет болса) құпия кілт
docker compose run --rm web mix phx.gen.secret
# шыққан мәнді .env ішіндегі SECRET_KEY_BASE-ке жазыңыз (жоқ болса, жасаңыз)

# 6) Қолданбаны көтеру
docker compose up -d web

# 7) Логтарды қарап, қателер бар-жоғын тексеру
docker compose logs -f web

# 8) Контейнер статусы
docker compose ps





docker compose run --rm web mix phx.gen.auth Lms.Accounts User users
# нұсқауларын орындайсыз (router-ге жолдарды қосу т.б.)
docker compose run --rm web mix ecto.migrate
docker compose restart web
