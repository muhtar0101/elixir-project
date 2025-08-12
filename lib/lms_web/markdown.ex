defmodule LmsWeb.Markdown do
  @moduledoc false
  # Қарапайым MD→HTML (Earmark)
  def to_html(md) do
    {:ok, html, _} = Earmark.as_html(md || "")
    html
  end
end
