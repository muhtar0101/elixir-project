defmodule Lms.Repo.Migrations.CreateCoursesLessons do
  use Ecto.Migration
  def change do
    create table(:courses) do
      add :title, :string, null: false
      add :slug, :string, null: false
      add :description, :text
      add :price_cents, :integer, null: false, default: 0
      add :published, :boolean, default: false
      timestamps()
    end
    create unique_index(:courses, [:slug])

    create table(:lessons) do
      add :course_id, references(:courses, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :position, :integer, null: false, default: 1
      add :lesson_type, :string, null: false # "video" | "text" | "test"
      add :free_preview, :boolean, default: false
      timestamps()
    end

    create index(:lessons, [:course_id])
    create index(:lessons, [:course_id, :position])
  end
end
