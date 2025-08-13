defmodule Lms.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @roles [:admin, :teacher, :student]

  schema "users" do
    field :email, :string
    field :login, :string
    field :full_name, :string
    field :phone, :string
    field :school, :string
    field :role, Ecto.Enum, values: @roles, default: :student

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :hashed_password, :string

    timestamps()
  end

  # Жалпы валидация көмекшісі
  defp base_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :login, :full_name, :phone, :school, :role])
    |> validate_format(:email, ~r/^\S+@\S+\.[\S]+$/)
    |> validate_length(:login, min: 3)
    |> validate_length(:full_name, min: 2)
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:login, name: :users_login_index)
  end

  # Тіркеу (user өзі немесе қарапайым create)
  def registration_changeset(user, attrs) do
    user
    |> base_changeset(attrs)
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, message: "Қайта енгізу сәйкес емес")
    |> put_password_hash()
  end

  # Админ арқылы жаңа қолданушы жасау (роль/логин міндеттелуі мүмкін)
  def admin_changeset(user, attrs) do
    user
    |> base_changeset(attrs)
    |> validate_required([:email, :role])
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, message: "Қайта енгізу сәйкес емес")
    |> put_password_hash()
  end

  # Профильді қолданушының өзі өзгертуі
  # login — тек бос болғанда ғана орнатамыз (бұрын бар болса өзгертуге тыйым)
  def profile_changeset(user, attrs) do
    user
    |> cast(attrs, [:full_name, :phone, :school])
    |> then(fn cs ->
      case {get_field(cs, :login) || user.login, user.login} do
        {nil, nil} -> cast(cs, attrs, [:login]) |> validate_length(:login, min: 3)
        {_, nil} -> cast(cs, attrs, [:login]) |> validate_length(:login, min: 3)
        _ -> cs # login бұрын орнатылған болса, оны өзгерпейміз
      end
    end)
    |> unique_constraint(:login, name: :users_login_index)
  end

  # Пароль өзгерту (қолданушы үшін)
  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, message: "Қайта енгізу сәйкес емес")
    |> put_password_hash()
  end

  # Админ парольін тікелей орнату
  def admin_password_changeset(user, attrs), do: password_changeset(user, attrs)

  defp put_password_hash(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
      |> delete_change(:password_confirmation)
    else
      changeset
    end
  end
end