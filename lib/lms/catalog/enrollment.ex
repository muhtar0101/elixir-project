defmodule Lms.Catalog.Enrollment do
  use Ecto.Schema
  import Ecto.Changeset
  schema "enrollments" do
    field :status, :string, default: "active"
    belongs_to :user, Lms.Accounts.User
    belongs_to :course, Lms.Catalog.Course
    timestamps()
  end
  def changeset(e, attrs) do
    e |> cast(attrs, [:status, :user_id, :course_id])
      |> validate_required([:status, :user_id, :course_id])
  end
end
