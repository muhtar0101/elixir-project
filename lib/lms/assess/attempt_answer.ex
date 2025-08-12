defmodule Lms.Assess.AttemptAnswer do
  use Ecto.Schema
  import Ecto.Changeset
  schema "attempt_answers" do
    field :answer_json, :map
    field :correct, :boolean, default: false
    belongs_to :attempt, Lms.Assess.Attempt
    belongs_to :question, Lms.Assess.Question
    timestamps()
  end
  def changeset(a, attrs) do
    a |> cast(attrs, [:answer_json, :correct, :attempt_id, :question_id])
      |> validate_required([:answer_json, :attempt_id, :question_id])
  end
end
