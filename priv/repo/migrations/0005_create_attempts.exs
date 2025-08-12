defmodule Lms.Repo.Migrations.CreateAttempts do
  use Ecto.Migration
  def change do
    create table(:attempts) do
      add :test_id, references(:tests, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :score, :integer, default: 0
      add :max_score, :integer, default: 0
      timestamps()
    end
    create index(:attempts, [:test_id, :user_id])

    create table(:attempt_answers) do
      add :attempt_id, references(:attempts, on_delete: :delete_all), null: false
      add :question_id, references(:questions, on_delete: :delete_all), null: false
      add :answer_json, :map, null: false
      add :correct, :boolean, default: false
      timestamps()
    end
    create index(:attempt_answers, [:attempt_id])
  end
end
