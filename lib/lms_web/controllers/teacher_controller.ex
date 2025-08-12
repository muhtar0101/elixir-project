defmodule LmsWeb.TeacherController do
  use LmsWeb, :controller
  def students(conn, _), do: send_resp(conn, 204, "")
  def create_student(conn, _), do: send_resp(conn, 204, "")
end
