defmodule LmsWeb.Admin.LessonEditLive do
  use LmsWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, assign(socket, :params, params)}
  end

  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-xl font-semibold">Lesson edit (placeholder)</h1>
      <div class="mt-2 text-sm text-gray-600">
        course_id = <%= @params["course_id"] %>, lesson id = <%= @params["id"] %>
      </div>
    </div>
    """
  end
end
