# config/dev.exs
import Config

port = String.to_integer(System.get_env("PORT") || "4000")
host = System.get_env("PHX_HOST") || "localhost"

config :lms, LmsWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: port],
  url: [host: host, port: port],
  live_view: [signing_salt: System.get_env("LIVE_VIEW_SIGNING_SALT") || "dev_salt_please_change_123"],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: System.get_env("SECRET_KEY_BASE") || "dev_secret_please_change_very_long",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    npm: ["run", "tw:dev", cd: Path.expand("../assets", __DIR__)]
  ]

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
