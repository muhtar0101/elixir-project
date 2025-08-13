defmodule LmsWeb.Auth.LoginLive do
  use LmsWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-md space-y-4">
      <h1 class="text-2xl font-semibold">Кіру</h1>

      <form action={~p"/login"} method="post" class="space-y-3">
        <input type="email" name="email" placeholder="Email" required class="input input-bordered w-full" />
        <input type="password" name="password" placeholder="Пароль" required class="input input-bordered w-full" />
        <button type="submit" class="btn btn-primary w-full">Кіру</button>
      </form>
    </div>
    """
  end
end
