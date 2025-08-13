defmodule LmsWeb.UserAuth do
  @moduledoc """
  Өте жеңіл auth-хелпер:
  - сессияға :uid қояды/өшiредi
  - conn.assigns.current_user орнатады
  - LiveView үшін on_mount беру
  - guard-плагтар: require_authenticated_user, require_admin
  """
  import Plug.Conn
  import Phoenix.Controller
  alias Lms.Accounts

  ## --------- Plug-тар

  # Router pipeline ішінде: plug :fetch_current_user
  def fetch_current_user(conn, _opts) do
    uid = get_session(conn, :uid)
    user = if uid, do: Accounts.get_user(uid), else: nil
    assign(conn, :current_user, user)
  end

  # Қорғалған беттер үшін:
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "Кіру қажет")
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end

  # Админ ғана кіретін беттер үшін:
  def require_admin(conn, _opts) do
    case conn.assigns[:current_user] do
      %{role: "admin"} -> conn
      _ ->
        conn
        |> put_flash(:error, "Тыйым салынған")
        |> redirect(to: ~p"/")
        |> halt()
    end
  end

  ## --------- Контроллерден шақырылады

  def log_in_user(conn, user, opts \\ []) do
    return_to = Keyword.get(opts, :return_to, ~p"/")
    conn
    |> configure_session(renew: true)
    |> put_session(:uid, user.id)
    |> redirect(to: return_to)
  end

  def log_out_user(conn) do
    conn
    |> configure_session(renew: true)
    |> delete_session(:uid)
    |> redirect(to: ~p"/")
  end

  ## --------- LiveView on_mount

  # LiveView-ге current_user беру үшін:
  def on_mount(:current_user, _params, session, socket) do
    uid = session["uid"]
    user = if uid, do: Accounts.get_user(uid), else: nil
    {:cont, Phoenix.Component.assign(socket, :current_user, user)}
  end

  # Қорғалған LiveView
  def on_mount(:require_authenticated_user, params, session, socket) do
    case on_mount(:current_user, params, session, socket) do
      {:cont, %{assigns: %{current_user: nil}} = _socket} ->
        {:halt,
         Phoenix.LiveView.redirect(socket,
           to: ~p"/login",
           flash: %{error: "Кіру қажет"}
         )}

      other -> other
    end
  end

  # Админ LiveView
  def on_mount(:require_admin, params, session, socket) do
    case on_mount(:current_user, params, session, socket) do
      {:cont, %{assigns: %{current_user: %{role: "admin"}}} = s} -> {:cont, s}
      _ ->
        {:halt,
         Phoenix.LiveView.redirect(socket,
           to: ~p"/",
           flash: %{error: "Тыйым салынған"}
         )}
    end
  end
end
