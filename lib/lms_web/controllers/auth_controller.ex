defmodule LmsWeb.AuthController do
  use LmsWeb, :controller
  alias Lms.Accounts
  alias Lms.Accounts.User

  def register_form(conn, _params) do
    render(conn, :register, changeset: Accounts.change_user(%User{}))
  end

  def create_user(conn, %{"user" => params}) do
    case Accounts.register_user(params) do
      {:ok, user} ->
        conn
        |> put_session(:uid, user.id)
        |> put_flash(:info, "Тіркелдіңіз!")
        |> redirect(to: ~p"/")
      {:error, %Ecto.Changeset{} = ch} ->
        render(conn, :register, changeset: ch)
    end
  end

  def login_form(conn, _params) do
    render(conn, :login)
  end

  def login(conn, %{"email" => e, "password" => p}) do
    case Accounts.verify_user(e, p) do
      {:ok, user} ->
        conn
        |> put_session(:uid, user.id)
        |> put_flash(:info, "Қош келдіңіз!")
        |> redirect(to: ~p"/")
      {:error, _} ->
        conn
        |> put_flash(:error, "Логин/пароль қате")
        |> render(:login)
    end
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/")
  end
end
