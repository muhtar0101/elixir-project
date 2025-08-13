defmodule LmsWeb.AuthController do
  use LmsWeb, :controller
  alias Lms.Accounts
  alias LmsWeb.UserAuth

  # Логин формасынан POST келеді
  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.verify_user(email, password) do
      {:ok, user} ->
        # phx.gen.auth жасаған helper: сессияны қойып, redirect жасайды
        conn |> UserAuth.log_in_user(user, return_to: ~p"/")
      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Қате email немесе пароль")
        |> redirect(to: ~p"/login")
    end
  end

  # LOGOUT (GET қылып та қоя салдық – ыңғайлы болсын)
  def delete(conn, _params) do
    conn |> UserAuth.log_out_user()
  end
end
