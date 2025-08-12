defmodule Lms.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Lms.Repo,
      {Phoenix.PubSub, name: Lms.PubSub},
      LmsWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Lms.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    LmsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
