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
    <div class="max-w-5xl mx-auto p-6">
      <h1 class="text-2xl font-bold mb-4"><%= @course.title %></h1>
      <p class="mb-6"><%= @course.description %></p>

      <h2 class="font-semibold mb-2">Сабақтар</h2>
      <ul class="space-y-2">
        <%= for l <- Enum.sort_by(@course.lessons, & &1.position) do %>
          <li class="flex items-center gap-3">
            <%= if l.free_preview or @enrolled? do %>
              <.link class="underline" navigate={~p"/courses/#{@course.slug}/lesson/#{l.id}"}><%= l.title %></.link>
            <% else %>
              <span class="opacity-60"><%= l.title %></span>
              <span class="px-2 py-0.5 text-xs rounded bg-gray-200">Құлып</span>
            <% end %>
          </li>
        <% end %>
      </ul>

      <%= unless @enrolled? do %>
      <form method="post" action={~p"/purchase/#{@course.slug}"} class="mt-4">
  <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
  <button type="submit" class="btn btn-primary">Курсты сатып алу</button>
</form>

      <% end %>
    </div>
    """
  end
end
