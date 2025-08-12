defmodule Lms.Catalog do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Lms.Repo
  alias Lms.Catalog.Course

  # Тек жарияланған курстар
  def list_published_courses do
    from(c in Course,
      where: c.published == true,
      order_by: [asc: c.position, asc: c.id]
    )
    |> Repo.all()
  end
end
