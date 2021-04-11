defmodule Web.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: Web.PubSub},
      Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Web.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
