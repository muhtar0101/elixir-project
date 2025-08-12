defmodule LmsWeb.AuthController do
  use LmsWeb, :controller
  alias Lms.Accounts

  # GET /login
  def login_form(conn, _params) do
    render(conn, :login)
  end

  # POST /login
  def login(conn, %{"email" => email, "password" => pass}) do
    case Accounts.verify_user(email, pass) do
      {:ok, user} ->
        conn
        |> put_session(:uid, user.id)
        |> put_flash(:info, "Қош келдіңіз!")
        |> redirect(to: ~p"/")
      _ ->
        conn
        |> put_flash(:error, "Email немесе пароль қате")
        |> render(:login)
    end
  end

  # GET /logout
  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/")
  end

  # GET /register
  def register_form(conn, _params) do
    render(conn, :register)
  end

  # POST /register
  def create_user(conn, %{"email" => email, "password" => pass}) do
    case Accounts.register_user(%{email: email, password: pass}) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Тіркелу сәтті!")
        |> redirect(to: ~p"/login")
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Қате. Деректерді тексеріңіз.")
        |> render(:register)
    end
  end
end
