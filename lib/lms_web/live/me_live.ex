# lib/lms_web/live/me_live.ex
defmodule LmsWeb.MeLive do
  use LmsWeb, :live_view

  def mount(_params, _session, socket), do: {:ok, socket}

  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-xl font-bold">Менің аккаунтым</h1>
      <p>Логиннен кейін осы бетке келесіз.</p>
    </div>
    """
  end
end
