defmodule Lms.Assess.Option do
  use Ecto.Schema
  import Ecto.Changeset
  schema "options" do
    field :label, :string
    field :correct, :boolean, default: false
    belongs_to :question, Lms.Assess.Question
    timestamps()
  end
  def changeset(o, attrs) do
    o |> cast(attrs, [:label, :correct, :question_id])
      |> validate_required([:label, :question_id])
  end
end
