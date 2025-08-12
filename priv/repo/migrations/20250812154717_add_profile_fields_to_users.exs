defmodule Lms.Repo.Migrations.AddProfileFieldsToUsers do
  use Ecto.Migration
  def change do
    alter table(:users) do
      add :city, :string
      add :school, :string
      add :grade, :integer
      add :teacher_id, references(:users, on_delete: :nilify_all)
      modify :role, :string, null: false, default: "student"  # "student" | "teacher" | "admin"
    end

    create index(:users, [:teacher_id])
  end
end
