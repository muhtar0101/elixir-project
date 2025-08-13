# lib/lms/accounts/accounts.ex
defmodule Lms.Accounts do
  import Ecto.Query, warn: false
  alias Lms.Repo
  alias Lms.Accounts.User

  # қажет жерлер қолданады
  def get_user(id), do: Repo.get(User, id)

  # Логин тексерісі
  def verify_user(email, password) do
    case Repo.get_by(User, email: email) do
      %User{} = u ->
        if Bcrypt.verify_pass(password, u.password_hash) do
          {:ok, u}
        else
          {:error, :invalid_credentials}
        end

      _ ->
        Bcrypt.no_user_verify()
        {:error, :invalid_credentials}
    end
  end
end
