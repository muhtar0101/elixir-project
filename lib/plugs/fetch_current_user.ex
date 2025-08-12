defmodule LmsWeb.FetchCurrentUser do
  import Plug.Conn
  alias Lms.Accounts

  def init(opts), do: opts
  def call(conn, _opts) do
    uid = get_session(conn, :uid)
    user = if uid, do: Accounts.get_user(uid)
    assign(conn, :current_user, user)
  end
end
