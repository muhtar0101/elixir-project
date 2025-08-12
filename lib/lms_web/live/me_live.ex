defmodule LmsWeb.MeLive do
  use LmsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-semibold">Менің кабинетім</h1>
    <p class="mt-2">Сәлем, <%= @current_user && @current_user.email %>!</p>
    <.link href="/logout" method="delete" class="underline mt-4 inline-block">Шығу</.link>
    """
  end
end
