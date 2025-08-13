defmodule Lms.Accounts do
  import Ecto.Query, warn: false
  alias Lms.Repo
  alias Lms.Accounts.User

  # ==== READ/LIST ====
  def list_users do
    from(u in User, order_by: [asc: u.id]) |> Repo.all()
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email(email) when is_binary(email), do: Repo.get_by(User, email: email)
  
  def get_user(id) when is_integer(id) or is_binary(id) do
    Lms.Accounts.User |> Lms.Repo.get(id)
  end

  # ==== CREATE ====
  def register_user(attrs), do: %User{} |> User.registration_changeset(attrs) |> Repo.insert()

  def admin_create_user(attrs), do: %User{} |> User.admin_changeset(attrs) |> Repo.insert()

  # ==== UPDATE ====
  def update_user_profile(%User{} = user, attrs), do: user |> User.profile_changeset(attrs) |> Repo.update()

  def admin_update_user(%User{} = user, attrs) do
    user
    |> User.admin_changeset(attrs)
    |> Repo.update()
  end

  # ==== PASSWORD ====
  def update_user_password(%User{} = user, current_password, attrs) do
    if Bcrypt.verify_pass(current_password, user.hashed_password) do
      user |> User.password_changeset(attrs) |> Repo.update()
    else
      {:error, Ecto.Changeset.add_error(Ecto.Changeset.change(user), :current_password, "Қазіргі паролі қате")}
    end
  end

  def admin_set_password(%User{} = user, attrs), do: user |> User.admin_password_changeset(attrs) |> Repo.update()

  # ==== AUTH (қарапайым) ====
  def verify_user(email, password) do
    case get_user_by_email(email) do
      %User{} = u ->
        if Bcrypt.verify_pass(password, u.hashed_password), do: {:ok, u}, else: {:error, :invalid_password}
      _ -> {:error, :not_found}
    end
  end
end
