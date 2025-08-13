defmodule Lms.Accounts do
  import Ecto.Query, warn: false
  alias Lms.Repo
  alias Lms.Accounts.User
  alias Bcrypt

  def change_user(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs)
  end

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def verify_user(email, password) do
    case Repo.get_by(User, email: email) do
      %User{} = u ->
        if Bcrypt.verify_pass(password, u.hashed_password) do
          {:ok, u}
        else
          {:error, :invalid_credentials}
        end

      _ -> {:error, :not_found}
    end
  end
end
