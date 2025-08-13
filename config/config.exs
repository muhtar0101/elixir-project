# config/config.exs
import Config

config :lms,
  ecto_repos: [Lms.Repo]

# Repo: web контейнері ішінен Postgres-ке қосылу
config :lms, Lms.Repo,
  database: "lms_db",
  username: "lms",
  password: "lms_pass",
  hostname: System.get_env("DB_HOST") || "db",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Endpoint: браузерден кіру хосты (сыртқы), PHX_HOST болмаса localhost
config :lms, LmsWeb.Endpoint,
  url: [
    host: System.get_env("PHX_HOST") || "localhost",
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  render_errors: [
    formats: [html: LmsWeb.ErrorHTML, json: LmsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Lms.PubSub,
  live_view: [signing_salt: "LVsalt"]

config :esbuild,
  version: "0.21.5",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2020 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind, version: "3.4.10",
  default: [
    args: ~w(--config=tailwind.config.js --input=css/app.css --output=../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

import_config "#{config_env()}.exs"
