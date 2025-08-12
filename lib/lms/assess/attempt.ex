defmodule Lms.Assess.Attempt do
  use Ecto.Schema
  import Ecto.Changeset
  schema "attempts" do
    field :score, :integer, default: 0
    field :max_score, :integer, default: 0
    belongs_to :test, Lms.Assess.Test
    belongs_to :user, Lms.Accounts.User
    has_many :answers, Lms.Assess.AttemptAnswer
    timestamps()
  end
  def changeset(a, attrs) do
    a |> cast(attrs, [:score, :max_score, :test_id, :user_id])
      |> validate_required([:test_id, :user_id])
  end
end
