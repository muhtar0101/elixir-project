# lib/lms_web/live/teacher_live.ex
defmodule LmsWeb.TeacherLive do
  use LmsWeb, :live_view

  def mount(_params, _session, socket), do: {:ok, socket}

  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-xl font-bold">Мұғалім панелі</h1>
      <p>Оқушылар тізімін, курс прогресін осында жасаймыз.</p>
    </div>
    """
  end
end
