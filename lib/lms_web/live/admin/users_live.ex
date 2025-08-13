defmodule LmsWeb.Admin.UsersLive do
  use LmsWeb, :live_view

  alias Lms.Accounts
  alias Lms.Accounts.User

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:users, Accounts.list_users())
     |> assign(:changeset, User.admin_changeset(%User{}, %{}))
     |> assign(:creating?, false)}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      %User{}
      |> User.admin_changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => params}, socket) do
    case Accounts.admin_create_user(params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Қолданушы қосылды")
         |> assign(:users, Accounts.list_users())
         |> assign(:changeset, User.admin_changeset(%User{}, %{}))}

      {:error, %Ecto.Changeset{} = cs} ->
        {:noreply, assign(socket, :changeset, Map.put(cs, :action, :insert))}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <h1 class="text-2xl font-semibold">Қолданушылар</h1>

      <div class="overflow-x-auto border rounded-2xl">
        <table class="min-w-full text-sm">
          <thead class="bg-gray-50">
            <tr class="text-left">
              <th class="p-3">ID</th>
              <th class="p-3">Аты-жөні</th>
              <th class="p-3">Email</th>
              <th class="p-3">Login</th>
              <th class="p-3">Role</th>
              <th class="p-3">Мектеп</th>
              <th class="p-3">Телефон</th>
              <th class="p-3">Әрекет</th>
            </tr>
          </thead>
          <tbody>
            <%= for u <- @users do %>
              <tr class="border-t hover:bg-gray-50">
                <td class="p-3"><%= u.id %></td>
                <td class="p-3"><%= u.full_name %></td>
                <td class="p-3"><%= u.email %></td>
                <td class="p-3"><%= u.login %></td>
                <td class="p-3"><%= u.role %></td>
                <td class="p-3"><%= u.school %></td>
                <td class="p-3"><%= u.phone %></td>
                <td class="p-3">
                  <.link navigate={~p"/admin/users/#{u.id}/edit"} class="underline">Өңдеу</.link>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>

      <div class="border rounded-2xl p-6">
        <h2 class="text-xl font-medium mb-4">Жаңа қолданушы</h2>
        <.simple_form for={@changeset} phx-change="validate" phx-submit="save">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <.input field={@changeset[:full_name]} label="Аты-жөні" />
            <.input field={@changeset[:email]} type="email" label="Email" />
            <.input field={@changeset[:login]} label="Login" />
            <.input field={@changeset[:school]} label="Мектеп" />
            <.input field={@changeset[:phone]} label="Телефон" />
            <.input field={@changeset[:role]} type="select" options={[:admin, :teacher, :student]} label="Role" />
            <.input field={@changeset[:password]} type="password" label="Пароль" />
            <.input field={@changeset[:password_confirmation]} type="password" label="Пароль (қайта)" />
          </div>
          <:actions>
            <.button phx-disable-with="Жүктелуде...">Қосу</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end
end