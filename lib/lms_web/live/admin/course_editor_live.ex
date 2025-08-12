defmodule LmsWeb.Admin.CourseEditorLive do
  use LmsWeb, :live_view
  alias Lms.{Repo}
  alias Lms.Catalog.{Course, Lesson}
  import Ecto.Changeset

  def mount(%{"id"=>id}, _s, socket) do
    course = Repo.get!(Course, id) |> Repo.preload(:lessons)
    {:ok, assign(socket, course: course, c_changeset: Course.changeset(course, %{}), l_changeset: Lesson.changeset(%Lesson{}, %{}))}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-5xl mx-auto p-6">
      <h1 class="text-2xl font-bold mb-4">Курс: <%= @course.title %></h1>

      <.simple_form for={@c_changeset} phx-submit="save_course">
        <.input field={@c_changeset[:title]} label="Атауы"/>
        <.input field={@c_changeset[:slug]} label="Slug"/>
        <.input field={@c_changeset[:description]} type="textarea" label="Сипаттама"/>
        <.input field={@c_changeset[:price_cents]} type="number" label="Баға (₸)"/>
        <.input field={@c_changeset[:published]} type="checkbox" label="Жариялау"/>
        <.button>Сақтау</.button>
      </.simple_form>

      <h2 class="mt-8 font-semibold">Сабақтар</h2>
      <ul class="mb-4">
        <%= for l <- Enum.sort_by(@course.lessons, & &1.position) do %>
          <li>
            <.link navigate={~p"/admin/courses/#{@course.id}/lessons/#{l.id}/edit"} class="underline"><%= l.position %>. <%= l.title %> (<%= l.lesson_type %>)</.link>
          </li>
        <% end %>
      </ul>

      <.simple_form for={@l_changeset} phx-submit="add_lesson">
        <.input field={@l_changeset[:title]} label="Сабақ атауы"/>
        <.input field={@l_changeset[:position]} type="number" label="Порядок"/>
        <.input field={@l_changeset[:lesson_type]} label="Түрі (video/text/test)"/>
        <.input field={@l_changeset[:free_preview]} type="checkbox" label="Preview"/>
        <.button>Қосу</.button>
      </.simple_form>
    </div>
    """
  end

  def handle_event("save_course", %{"course" => params}, socket) do
    cs = Lms.Catalog.Course.changeset(socket.assigns.course, params)
    case Repo.update(cs) do
      {:ok, c} -> {:noreply, assign(socket, course: Repo.preload(c, :lessons), c_changeset: cs)}
      {:error, cs} -> {:noreply, assign(socket, c_changeset: cs)}
    end
  end

  def handle_event("add_lesson", %{"lesson" => params}, socket) do
    params = Map.put(params, "course_id", socket.assigns.course.id)
    cs = Lms.Catalog.Lesson.changeset(%Lms.Catalog.Lesson{}, params)
    case Repo.insert(cs) do
      {:ok, _} ->
        course = Lms.Repo.get!(Lms.Catalog.Course, socket.assigns.course.id) |> Repo.preload(:lessons)
        {:noreply, assign(socket, course: course, l_changeset: Lms.Catalog.Lesson.changeset(%Lms.Catalog.Lesson{}, %{}))}
      {:error, cs} ->
        {:noreply, assign(socket, l_changeset: cs)}
    end
  end
end
