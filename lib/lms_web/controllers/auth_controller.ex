defmodule LmsWeb.AuthController do
  use LmsWeb, :controller
  alias Lms.Accounts
  alias LmsWeb.UserAuth

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.verify_user(email, password) do
      {:ok, user} ->
        conn
        |> UserAuth.log_in_user(user) # phx.gen.auth жасаған helper
      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Қате email немесе пароль")
        |> redirect(to: ~p"/login")
    end
  end
end
