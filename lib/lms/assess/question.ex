defmodule Lms.Assess.Question do
  use Ecto.Schema
  import Ecto.Changeset
  schema "questions" do
    field :qtype, :string # "open" | "single" | "multiple" | "match"
    field :prompt_md, :string
    field :position, :integer, default: 1
    belongs_to :test, Lms.Assess.Test
    has_many :options, Lms.Assess.Option
    has_many :match_pairs, Lms.Assess.MatchPair
    timestamps()
  end

  def changeset(q, attrs) do
    q |> cast(attrs, [:qtype, :prompt_md, :position, :test_id])
      |> validate_inclusion(:qtype, ["open","single","multiple","match"])
      |> validate_required([:qtype, :prompt_md, :test_id])
  end
end
