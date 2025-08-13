# lib/lms/accounts/user.ex
defmodule Lms.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @roles ~w(admin teacher student)a

  schema "users" do
    field :email, :string
    field :role,  :string, default: "student"
    field :password_hash, :string

    # virtual (формадан келеді, БД-да сақталмайды):
    field :password, :string, virtual: true

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :role, :password])
    |> validate_required([:email, :role])
  end
  @doc """
  Тіркеуге арналған changeset (құпиясөзді хэштап жазады).
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :role])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6)
    |> validate_inclusion(:role, Enum.map(@roles, &to_string/1))
    |> put_password_hash()
  end

  @doc """
  Логинге арналған changeset (валидация ғана, хэштамайды).
  """
  def login_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end

  defp put_password_hash(changeset) do
    if pwd = get_change(changeset, :password) do
      change(changeset, password_hash: Bcrypt.hash_pwd_salt(pwd))
    else
      changeset
    end
  end
end
