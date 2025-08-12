defmodule LmsWeb.MeLive do
  use LmsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Менің бетім")}
  end

  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold">Сәлем! Бұл — жеке кабинет.</h1>
      <p class="mt-2 text-sm text-zinc-600">Мұнда сатып алған курстар мен нәтижелер шығады.</p>
    </div>
    """
  end
end
