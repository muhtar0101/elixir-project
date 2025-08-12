defmodule Lms.Catalog.Purchase do
  use Ecto.Schema
  import Ecto.Changeset
  schema "purchases" do
    field :amount_cents, :integer
    field :state, :string, default: "paid"
    belongs_to :user, Lms.Accounts.User
    belongs_to :course, Lms.Catalog.Course
    timestamps()
  end
  def changeset(p, attrs) do
    p |> cast(attrs, [:amount_cents, :state, :user_id, :course_id])
      |> validate_required([:amount_cents, :state, :user_id, :course_id])
  end
end
