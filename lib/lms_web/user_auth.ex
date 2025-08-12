defmodule LmsWeb.UserAuth do
  import Phoenix.Controller
  alias Lms.Accounts

  # LiveView on_mount хук: сессиядан user жүктеу
  def on_mount(:load_current_user, _params, session, socket) do
    uid = session["uid"]
    user = if uid, do: Accounts.get_user(uid), else: nil
    {:cont, Phoenix.Component.assign(socket, current_user: user)}
  end

  # Тек логинмен кіргендерге (LiveView ішінде)
  def on_mount(:require_authenticated, _params, session, socket) do
    uid = session["uid"]
    user = if uid, do: Accounts.get_user(uid), else: nil
    if user, do: {:cont, Phoenix.Component.assign(socket, current_user: user)},
      else: {:halt, Phoenix.LiveView.redirect(socket, to: "/login")}
  end
end
