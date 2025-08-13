# config/runtime.exs
import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise "DATABASE_URL is missing. Example: ecto://USER:PASS@HOST/DATABASE"

  config :lms, Lms.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "SECRET_KEY_BASE is missing. Generate: mix phx.gen.secret"

  config :lms, LmsWeb.Endpoint, secret_key_base: secret_key_base
end

# dev/test конфигі config/dev.exs және config/test.exs ішінде қалады
