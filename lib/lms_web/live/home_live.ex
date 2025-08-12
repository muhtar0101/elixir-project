defmodule LmsWeb.HomeLive do
  use LmsWeb, :live_view
  alias Lms.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, courses: Catalog.list_published_courses())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header class="mb-4">Курстар</.header>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <%= for c <- @courses do %>
        <.link navigate={~p"/courses/#{c.slug}"} class="block border rounded-xl p-4 hover:shadow">
          <div class="font-semibold"><%= c.title %></div>
          <div class="text-sm opacity-75"><%= c.description %></div>
        </.link>
      <% end %>
      <%= if @courses == [] do %>
        <div class="text-sm opacity-70">Әзірге жарияланған курс жоқ.</div>
      <% end %>
    </div>
    """
  end
end
