defmodule LmsWeb.Plugs.RequireAdmin do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.assigns[:current_user] do
      %{role: :admin} -> conn
      %{role: role} when role in ["admin"] -> conn # ескі жазба жағдайына сақтық
      _ ->
        conn
        |> put_flash(:error, "Админ рұқсаты қажет")
        |> redirect(to: "/")
        |> halt()
    end
  end
end