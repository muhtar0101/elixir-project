defmodule LmsWeb.Admin.UserEditLive do
  use LmsWeb, :live_view

  alias Lms.Accounts
  alias Lms.Accounts.User

  def mount(%{"id" => id}, _session, socket) do
    user = Accounts.get_user!(id)

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:changeset, User.admin_changeset(user, %{}))
     |> assign(:pwd_changeset, User.admin_password_changeset(user, %{}))}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    cs = socket.assigns.user |> User.admin_changeset(params) |> Map.put(:action, :validate)
    {:noreply, assign(socket, :changeset, cs)}
  end

  def handle_event("save", %{"user" => params}, socket) do
    case Accounts.admin_update_user(socket.assigns.user, params) do
      {:ok, user} ->
        {:noreply, socket |> put_flash(:info, "Сақталды") |> assign(:user, user) |> assign(:changeset, User.admin_changeset(user, %{}))}
      {:error, %Ecto.Changeset{} = cs} -> {:noreply, assign(socket, :changeset, Map.put(cs, :action, :insert))}
    end
  end

  def handle_event("validate_pwd", %{"user" => params}, socket) do
    cs = socket.assigns.user |> User.admin_password_changeset(params) |> Map.put(:action, :validate)
    {:noreply, assign(socket, :pwd_changeset, cs)}
  end

  def handle_event("save_pwd", %{"user" => params}, socket) do
    case Accounts.admin_set_password(socket.assigns.user, params) do
      {:ok, user} ->
        {:noreply, socket |> put_flash(:info, "Пароль жаңартылды") |> assign(:user, user) |> assign(:pwd_changeset, User.admin_password_changeset(user, %{}))}
      {:error, %Ecto.Changeset{} = cs} -> {:noreply, assign(socket, :pwd_changeset, Map.put(cs, :action, :insert))}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <.link navigate={~p"/admin/users"} class="underline">← Барлық қолданушы</.link>
      <h1 class="text-2xl font-semibold">Қолданушыны өңдеу: <%= @user.email %></h1>

      <div class="grid md:grid-cols-2 gap-6">
        <div class="border rounded-2xl p-6">
          <h2 class="text-lg font-medium mb-4">Жалпы деректер</h2>
          <.simple_form for={@changeset} phx-change="validate" phx-submit="save">
            <.input field={@changeset[:full_name]} label="Аты-жөні" />
            <.input field={@changeset[:email]} type="email" label="Email" />
            <.input field={@changeset[:login]} label="Login" />
            <.input field={@changeset[:school]} label="Мектеп" />
            <.input field={@changeset[:phone]} label="Телефон" />
            <.input field={@changeset[:role]} type="select" options={[:admin, :teacher, :student]} label="Role" />
            <:actions><.button phx-disable-with="Сақталуда...">Сақтау</.button></:actions>
          </.simple_form>
        </div>

        <div class="border rounded-2xl p-6">
          <h2 class="text-lg font-medium mb-4">Парольді ауыстыру (админ)</h2>
          <.simple_form for={@pwd_changeset} phx-change="validate_pwd" phx-submit="save_pwd">
            <.input field={@pwd_changeset[:password]} type="password" label="Жаңа пароль" />
            <.input field={@pwd_changeset[:password_confirmation]} type="password" label="Жаңа пароль (қайта)" />
            <:actions><.button phx-disable-with="Сақталуда...">Жаңарту</.button></:actions>
          </.simple_form>
        </div>
      </div>
    </div>
    """
  end
end