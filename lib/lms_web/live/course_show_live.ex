defmodule LmsWeb.CourseShowLive do
  use LmsWeb, :live_view
  import Ecto.Query
  alias Lms.{Repo}
  alias Lms.Catalog.{Course, Lesson, Enrollment}
  alias Lms.Accounts.User

  def mount(%{"slug"=>slug}, session, socket) do
    uid = session["uid"]
    course = Repo.get_by!(Course, slug: slug) |> Repo.preload(:lessons)
    enrolled? =
      if uid do
        !!Repo.get_by(Enrollment, user_id: uid, course_id: course.id)
      else
        false
      end
    {:ok, assign(socket, course: course, enrolled?: enrolled?)}
  end

  def render(assigns) do
  ~H"""
  <div class="space-y-4">
    <!-- басқа контент -->

    <form method="post" action={~p"/purchase/#{@course.slug}"} class="mt-4">
      <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
      <button type="submit" class="btn btn-primary">Курсты сатып алу</button>
    </form>
  </div>
  """
end
end
