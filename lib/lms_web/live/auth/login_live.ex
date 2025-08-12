defmodule LmsWeb.Auth.LoginLive do
  use LmsWeb, :live_view

  def render(assigns) do
   ~H"""
<.simple_form for={@form} action={~p"/login"} method="post">
  <.input field={@form[:email]} label="Email" />
  <.input field={@form[:password]} type="password" label="Пароль" />
  <.button>Кіру</.button>
</.simple_form>
<p class="mt-4"><.link navigate={~p"/register"}>Тіркелу</.link></p>
"""
  end

  def mount(_, _, socket) do
    {:ok, assign(socket, form: to_form(%{}))}
  end

  def handle_event("login", %{"email" => e, "password" => p}, socket) do
    case Lms.Accounts.verify_user(e, p) do
      {:ok, u} ->
        {:noreply, push_navigate(Phoenix.Component.assign(socket, :flash, %{}), to: ~p"/", replace: true)
        |> then(fn s -> Phoenix.LiveView.put_session(s, :uid, u.id) end)}
      _ ->
        {:noreply, put_flash(socket, :error, "Қате логин/пароль")}
    end
  end
end
