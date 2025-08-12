defmodule Lms.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt, as: Pwd

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :role, :string, default: "student"
    timestamps()
  end

  @doc "Жаңа қолданушыға арналған changeset (hash жасайды)"
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :role])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = cs),
    do: change(cs, password_hash: Pwd.hash_pwd_salt(pass))
  defp put_pass_hash(cs), do: cs
end
