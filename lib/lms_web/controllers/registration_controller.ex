defmodule LmsWeb.RegistrationController do
  use LmsWeb, :controller
  alias Lms.Accounts

  def new(conn, _), do: render(conn, :new)

  def create(conn, %{"user" => params}) do
    case Accounts.register_user(params) do
      {:ok, user} ->
        conn
        |> put_session(:uid, user.id)
        |> put_flash(:info, "Тіркелу сәтті!")
        |> redirect(to: ~p"/")
      {:error, cs} ->
        render(conn, :new, changeset: cs)
    end
  end
end
