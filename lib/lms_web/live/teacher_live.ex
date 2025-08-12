defmodule LmsWeb.TeacherLive do
  use LmsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-semibold">Мұғалім кабинеті</h1>
    <p class="mt-2">Қош келдіңіз, <%= @current_user && @current_user.email %>!</p>
    <.link href="/logout" method="delete" class="underline mt-4 inline-block">Шығу</.link>
    """
  end
end
