defmodule Lms.Repo.Migrations.CreateTestsQuestions do
  use Ecto.Migration
  def change do
    create table(:tests) do
      add :lesson_id, references(:lessons, on_delete: :delete_all), null: false
      add :title, :string, null: false
      timestamps()
    end
    create index(:tests, [:lesson_id])

    create table(:questions) do
      add :test_id, references(:tests, on_delete: :delete_all), null: false
      add :qtype, :string, null: false # "open" | "single" | "multiple" | "match"
      add :prompt_md, :text, null: false
      add :position, :integer, null: false, default: 1
      timestamps()
    end
    create index(:questions, [:test_id, :position])

    create table(:options) do
      add :question_id, references(:questions, on_delete: :delete_all), null: false
      add :label, :text, null: false
      add :correct, :boolean, default: false
      timestamps()
    end
    create index(:options, [:question_id])

    create table(:match_pairs) do
      add :question_id, references(:questions, on_delete: :delete_all), null: false
      add :left_text, :text, null: false
      add :right_text, :text, null: false
      timestamps()
    end
    create index(:match_pairs, [:question_id])
  end
end
