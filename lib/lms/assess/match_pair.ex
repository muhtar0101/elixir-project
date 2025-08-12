defmodule Lms.Assess.MatchPair do
  use Ecto.Schema
  import Ecto.Changeset
  schema "match_pairs" do
    field :left_text, :string
    field :right_text, :string
    belongs_to :question, Lms.Assess.Question
    timestamps()
  end
  def changeset(m, attrs) do
    m |> cast(attrs, [:left_text, :right_text, :question_id])
      |> validate_required([:left_text, :right_text, :question_id])
  end
end
