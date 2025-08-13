defmodule Lms.Repo.Migrations.AddProfileFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :login, :string
      add :full_name, :string
      add :phone, :string
      add :school, :string
      add :role, :string, null: false, default: "student"
    end

    create unique_index(:users, [:email], name: :users_email_index, if_not_exists: true)
    create unique_index(:users, [:login], name: :users_login_index, if_not_exists: true)
  end
end