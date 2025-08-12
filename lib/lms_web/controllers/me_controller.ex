defmodule LmsWeb.MeController do
  use LmsWeb, :controller
  def shelf(conn, _), do: send_resp(conn, 204, "")
  def courses(conn, _), do: send_resp(conn, 204, "")
  def results(conn, _), do: send_resp(conn, 204, "")
end
