defmodule LmsWeb do
  @moduledoc false
  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, formats: [:html, :json], layouts: [html: {LmsWeb.Layouts, :root}]
      import Plug.Conn
      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView, layout: {LmsWeb.Layouts, :root}
      import Phoenix.Component
      import LmsWeb.CoreComponents     # << МІНДЕТТІ: .input/.button/.simple_form үшін
      unquote(verified_routes())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent
      import Phoenix.Component
      import LmsWeb.CoreComponents
      unquote(verified_routes())
    end
  end

  def html do
    quote do
      use Phoenix.Component
      import Phoenix.HTML
      import LmsWeb.CoreComponents
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: LmsWeb.Endpoint,
        router: LmsWeb.Router,
        statics: LmsWeb.static_paths()
    end
  end

  defmacro __using__(which) when is_atom(which), do: apply(__MODULE__, which, [])
end
