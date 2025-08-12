defmodule Lms.Repo.Migrations.CreateEnrollmentsPurchases do
  use Ecto.Migration
  def change do
    create table(:enrollments) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :course_id, references(:courses, on_delete: :delete_all), null: false
      add :status, :string, null: false, default: "active" # active | revoked
      timestamps()
    end
    create unique_index(:enrollments, [:user_id, :course_id])

    create table(:purchases) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :course_id, references(:courses, on_delete: :delete_all), null: false
      add :amount_cents, :integer, null: false
      add :state, :string, null: false, default: "paid" # MVP: always "paid"
      timestamps()
    end
    create index(:purchases, [:user_id, :course_id])
  end
end
