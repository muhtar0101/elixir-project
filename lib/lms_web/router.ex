defmodule LmsWeb.Router do
  use LmsWeb, :router

  import Phoenix.LiveView.Router

  # Егер phx.gen.auth арқылы UserAuth модулі бар болса:
  # plug-тарды осылай қосамыз (fetch_current_user керек)
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LmsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug LmsWeb.UserAuth, :fetch_current_user
  end

  pipeline :admin do
    plug LmsWeb.Plugs.RequireAdmin
  end

  scope "/", LmsWeb do
    pipe_through :browser

    # әдеттегі беттеріңіз...

    live "/settings", SettingsLive, :index
  end

  scope "/admin", LmsWeb do
    pipe_through [:browser, :admin]

    live "/users", Admin.UsersLive, :index
    live "/users/:id/edit", Admin.UserEditLive, :edit
  end
end