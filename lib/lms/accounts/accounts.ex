defmodule Lms.Accounts do
  import Ecto.Query, warn: false
  alias Lms.Repo
  alias Lms.Accounts.User

  # Басқа жерлер (plug және т.б.) қолданады
  def get_user(id), do: Repo.get(User, id)

  # Email+пароль тексерісі
  def verify_user(email, password) do
    case Repo.get_by(User, email: email) do
      %User{} = u ->
        if Bcrypt.verify_pass(password, u.password_hash) do
          {:ok, u}
        else
          {:error, :invalid_credentials}
        end

      _ ->
        # timing attack-қа қарсы
        Bcrypt.no_user_verify()
        {:error, :invalid_credentials}
    end
  end
end
