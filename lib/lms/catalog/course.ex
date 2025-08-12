defmodule Lms.Catalog.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :title, :string
    field :slug, :string
    field :description, :string
    field :published, :boolean, default: false
    field :price_kzt, :integer
    field :position, :integer, default: 0

    has_many :lessons, Lms.Catalog.Lesson
    timestamps()
  end

  def changeset(course, attrs) do
    course
    |> cast(attrs, [:title, :slug, :description, :published, :price_kzt, :position])
    |> validate_required([:title, :slug])
    |> unique_constraint(:slug)
  end
end
