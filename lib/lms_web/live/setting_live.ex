defmodule LmsWeb.SettingsLive do
  use LmsWeb, :live_view
  alias Lms.Accounts
  alias Lms.Accounts.User

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    {:ok,
     socket
     |> assign(:user, current_user)
     |> assign(:profile_cs, User.profile_changeset(current_user, %{}))
     |> assign(:password_cs, User.password_changeset(current_user, %{}))}
  end

  # Профиль
  def handle_event("validate_profile", %{"user" => params}, socket) do
    cs = socket.assigns.user |> User.profile_changeset(params) |> Map.put(:action, :validate)
    {:noreply, assign(socket, :profile_cs, cs)}
  end

  def handle_event("save_profile", %{"user" => params}, socket) do
    case Accounts.update_user_profile(socket.assigns.user, params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Профиль жаңартылды")
         |> assign(:user, user)
         |> assign(:profile_cs, User.profile_changeset(user, %{}))}

      {:error, %Ecto.Changeset{} = cs} ->
        {:noreply, assign(socket, :profile_cs, Map.put(cs, :action, :insert))}
    end
  end

  # Пароль (қолданушы өзі — current_password талап етіледі)
  def handle_event("validate_password", %{"user" => params}, socket) do
    cs = socket.assigns.user |> User.password_changeset(params) |> Map.put(:action, :validate)
    {:noreply, assign(socket, :password_cs, cs)}
  end

  def handle_event("save_password", %{"user" => %{"current_password" => curr} = params}, socket) do
    case Accounts.update_user_password(socket.assigns.user, curr, params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Пароль жаңартылды")
         |> assign(:user, user)
         |> assign(:password_cs, User.password_changeset(user, %{}))}

      {:error, %Ecto.Changeset{} = cs} -> {:noreply, assign(socket, :password_cs, Map.put(cs, :action, :insert))}
    end
  end

  def render(assigns) do
  ~H"""
  <div class="space-y-8">
    <h1 class="text-2xl font-semibold">Параметрлер</h1>

    <div class="grid md:grid-cols-2 gap-6">
      <div class="border rounded-2xl p-6">
        <h2 class="text-lg font-medium mb-4">Профиль</h2>
        <.simple_form for={@profile_cs} phx-change="validate_profile" phx-submit="save_profile">
          <.input field={@profile_cs[:full_name]} label="Аты-жөні" />
          <.input field={@profile_cs[:school]} label="Мектеп" />
          <.input field={@profile_cs[:phone]} label="Телефон" />

          <%= if is_nil(@user.login) do %>
            <.input field={@profile_cs[:login]} label="Login (бір рет)" />
          <% else %>
            <div class="text-sm text-gray-600">Login: <b><%= @user.login %></b> (өзгертілмейді)</div>
          <% end %>

          <button type="submit" class="mt-3 px-4 py-2 rounded-md bg-blue-600 text-white">Сақтау</button>
        </.simple_form>
      </div>

      <div class="border rounded-2xl p-6">
        <h2 class="text-lg font-medium mb-4">Пароль</h2>
        <.simple_form for={@password_cs} phx-change="validate_password" phx-submit="save_password">
          <div class="flex flex-col gap-1">
            <label for="curr_pwd" class="text-sm font-medium">Қазіргі пароль</label>
            <input id="curr_pwd" name="user[current_password]" type="password" class="border rounded-md p-2" />
          </div>

          <.input field={@password_cs[:password]} type="password" label="Жаңа пароль" />
          <.input field={@password_cs[:password_confirmation]} type="password" label="Жаңа пароль (қайта)" />

          <button type="submit" class="mt-3 px-4 py-2 rounded-md bg-blue-600 text-white">Жаңарту</button>
        </.simple_form>
      </div>
    </div>
  </div>
  """
end

end
