defmodule Lms.Repo.Migrations.CreateLessonContents do
  use Ecto.Migration
  def change do
    create table(:lesson_contents) do
      add :lesson_id, references(:lessons, on_delete: :delete_all), null: false
      add :format, :string, null: false, default: "html" # "html" | "md" | "video" | "url" т.с.с.
      add :body, :text
      timestamps()
    end

    create unique_index(:lesson_contents, [:lesson_id])
  end
end
