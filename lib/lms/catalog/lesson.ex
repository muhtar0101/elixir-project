defmodule Lms.Catalog.Lesson do
  use Ecto.Schema
  import Ecto.Changeset

  @type_values [:video, :text, :test]

  schema "lessons" do
    field :title, :string
    field :lesson_type, Ecto.Enum, values: @type_values
    field :content_md, :string
    field :position, :integer, default: 0
    field :free_preview, :boolean, default: false

    belongs_to :course, Lms.Catalog.Course
    timestamps()
  end

  def changeset(lesson, attrs) do
    lesson
    |> cast(attrs, [:title, :lesson_type, :content_md, :position, :free_preview, :course_id])
    |> validate_required([:title, :lesson_type, :course_id])
  end
end
