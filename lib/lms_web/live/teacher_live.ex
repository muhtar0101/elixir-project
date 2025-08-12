defmodule LmsWeb.TeacherLive do
  use LmsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Мұғалім панелі")}
  end

  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold">Мұғалім панелі</h1>
      <p class="mt-2 text-sm text-zinc-600">Оқушылар тізімі, топтар, нәтижелер т.б. осында болады.</p>
    </div>
    """
  end
end
