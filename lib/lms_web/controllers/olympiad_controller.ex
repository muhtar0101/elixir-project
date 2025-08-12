defmodule LmsWeb.OlympiadController do
  use LmsWeb, :controller
  def index(conn, _), do: send_resp(conn, 204, "")
  def register(conn, _), do: send_resp(conn, 204, "")
  def results(conn, _), do: send_resp(conn, 204, "")
end
