# lib/lms_web/endpoint.ex
defmodule LmsWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :lms

  # Сессия cookie арқылы сақталады (қажет болса қорғалған/шифрланған етесіз)
  @session_options [
    store: :cookie,
    key: "_lms_key",
    signing_salt: "signsalt",
    same_site: "Lax"
  ]

  # LiveView сокеті (session мәліметін беру маңызды)
  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]]

  # Статик ресурстар (assets, images, т.б.)
  plug Plug.Static,
    at: "/",
    from: :lms,
    gzip: false,
    only: LmsWeb.static_paths()

  # Code reloader (dev ортасы үшін)
  if code_reloading? do
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :lms
  end

  # Request logger (LiveDashboard үшін ыңғайлы)
  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug LmsWeb.Router
end
