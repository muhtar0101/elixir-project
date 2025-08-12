defmodule Lms.Assess.Test do
  use Ecto.Schema
  import Ecto.Changeset
  schema "tests" do
    field :title, :string
    belongs_to :lesson, Lms.Catalog.Lesson
    has_many :questions, Lms.Assess.Question
    timestamps()
  end
  def changeset(t, attrs) do
    t |> cast(attrs, [:title, :lesson_id]) |> validate_required([:title, :lesson_id])
  end
end
