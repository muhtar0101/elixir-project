defmodule Lms.Content.LessonContent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lesson_contents" do
    field :format, :string # "html" | "md" | "video"
    field :body, :string   # html/md мәтін; видео url болса body=URL
    belongs_to :lesson, Lms.Catalog.Lesson
    timestamps()
  end

  def changeset(content, attrs) do
    content
    |> cast(attrs, [:format, :body, :lesson_id])
    |> validate_inclusion(:format, ["html", "md", "video"])
    |> validate_required([:format, :body, :lesson_id])
  end
end
