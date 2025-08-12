defmodule LmsWeb.AuthController do
  use LmsWeb, :controller
  alias Lms.Accounts

  def register_form(conn, _), do: render(conn, :register)

  def create_user(conn, %{"user" => %{"email" => e, "password" => p, "role" => r}}) do
    case Accounts.register_user(%{email: e, password: p, role: r}) do
      {:ok, _u} ->
        conn
        |> put_flash(:info, "Тіркелу сәтті. Енді кіріңіз.")
        |> redirect(to: ~p"/login")
      {:error, cs} ->
        conn |> put_flash(:error, "Қате: #{inspect(cs.errors)}") |> redirect(to: ~p"/register")
    end
  end

  def login_form(conn, _), do: render(conn, :login)

  def login(conn, %{"email" => e, "password" => p}) do
    case Accounts.verify_user(e, p) do
      {:ok, u} ->
        conn
        |> put_session(:uid, u.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "Қош келдіңіз!")
        |> redirect(to: role_home(u))
      {:error, _} ->
        conn |> put_flash(:error, "Email немесе пароль қате") |> redirect(to: ~p"/login")
    end
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Сіз шықтыңыз.")
    |> redirect(to: ~p"/")
  end

  defp role_home(%{role: "teacher"}), do: ~p"/teacher"
  defp role_home(%{role: "admin"}), do: ~p"/admin"
  defp role_home(_), do: ~p"/me"
end
