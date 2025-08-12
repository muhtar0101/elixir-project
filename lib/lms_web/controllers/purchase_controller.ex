defmodule LmsWeb.PurchaseController do
  use LmsWeb, :controller
  alias Lms.{Repo}
  alias Lms.Catalog.{Course, Purchase, Enrollment}

  def create(conn, %{"slug"=>slug}) do
    uid = get_session(conn, :uid)
    unless uid do
      conn |> put_flash(:error, "Алдымен кіріңіз") |> redirect(to: ~p"/login") |> halt()
    else
      course = Repo.get_by!(Course, slug: slug)
      {:ok, _} =
        %Purchase{} |> Purchase.changeset(%{
          user_id: uid, course_id: course.id,
          amount_cents: course.price_cents, state: "paid"
        }) |> Repo.insert()

      _ = %Enrollment{} |> Enrollment.changeset(%{user_id: uid, course_id: course.id, status: "active"}) |> Repo.insert(on_conflict: :nothing, conflict_target: [:user_id, :course_id])

      conn |> put_flash(:info, "Курс сатып алынды") |> redirect(to: ~p"/courses/#{slug}")
    end
  end
end
