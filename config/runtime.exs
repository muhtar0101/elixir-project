import Config

if config_env() == :prod do
  # Prod-қа өзіңнің PROD env-теріңді қойып аласың
end

host = System.get_env("PHX_HOST", "localhost")
port = String.to_integer(System.get_env("PORT", "4000"))

config :lms, LmsWeb.Endpoint,
  url: [host: host, port: port, scheme: "http"],
  http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}, port: port],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  live_view: [signing_salt: System.fetch_env!("LIVE_VIEW_SIGNING_SALT")]
