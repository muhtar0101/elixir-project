defmodule Lms.Accounts do
  import Ecto.Query
  alias Lms.Repo
  alias Lms.Accounts.User
  alias Bcrypt, as: Pwd

  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)
  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  def register_user(attrs) do
    %User{} |> User.registration_changeset(attrs) |> Repo.insert()
  end

  @doc "Логин тексеру — логта warning болған verify_user/2 осында"
  def verify_user(email, password) do
    with %User{} = u <- get_user_by_email(email),
         true <- Pwd.verify_pass(password, u.password_hash) do
      {:ok, u}
    else
      _ -> {:error, :invalid_credentials}
    end
  end
end
