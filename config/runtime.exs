import Config

if config_env() == :dev do
  host = System.get_env("PHX_HOST", "localhost")
  port = String.to_integer(System.get_env("PORT", "4000"))
  secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
  signing_salt = System.fetch_env!("LIVE_VIEW_SIGNING_SALT")

  config :lms, LmsWeb.Endpoint,
     secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
    live_view: [signing_salt: System.fetch_env!("LIVE_VIEW_SIGNING_SALT")],
    server: System.get_env("PHX_SERVER") == "true"
end
