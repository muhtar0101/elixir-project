# config/dev.exs
import Config

config :lms, Lms.Repo,
  url: System.get_env("DATABASE_URL") || "ecto://postgres:postgres@db:5432/lms_dev",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  show_sensitive_data_on_connection_error: true,
  stacktrace: true

config :lms, LmsWeb.Endpoint,
  http: [ip: {0,0,0,0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: System.get_env("SECRET_KEY_BASE") || "dev-key"

config :logger, :console, format: "[$level] $message\n"

# config/dev.exs
config :lms, LmsWeb.Endpoint,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]
# config/dev.exs
#config :lms, Lms.Mailer, adapter: Swoosh.Adapters.Local
