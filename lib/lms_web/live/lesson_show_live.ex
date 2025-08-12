defmodule LmsWeb.LessonShowLive do
  use LmsWeb, :live_view
  alias Lms.Repo
  alias Lms.Catalog.{Course, Lesson}

  @impl true
  def mount(%{"slug" => slug, "id" => id}, _session, socket) do
    course = Repo.get_by!(Course, slug: slug)
    lesson = Repo.get!(Lesson, id)

    {:ok,
     socket
     |> assign(:course, course)
     |> assign(:lesson, lesson)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.link navigate={~p"/courses/#{@course.slug}"} class="text-sm underline">← Артқа</.link>
    <h1 class="text-2xl font-semibold mt-2"><%= @lesson.title %></h1>

    <%= case @lesson.lesson_type do %>
      <% :text -> %>
        <div class="prose max-w-none mt-4">
         <%= Phoenix.HTML.raw(Earmark.as_html!(@lesson.content_md || "")) %>
        </div>

      <% :video -> %>
        <div class="mt-4">
          <%# MVP: content_md ішінде видео сілтеме сақталады %>
          <video class="w-full rounded" src={@lesson.content_md} controls></video>
        </div>

      <% :test -> %>
        <div class="mt-4 border rounded p-4 bg-amber-50">
          Тест модулі әзірлену үстінде. Бұл сабақты кейін толық қосамыз.
        </div>

      <% _ -> %>
        <div class="mt-4 text-sm opacity-70">Сабақ түрі қолдау таппайды.</div>
    <% end %>
    """
  end
end
