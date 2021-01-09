defmodule Web.Application do
  use Application

  def start(_type, _args) do
    children = [Web.Endpoint]
    opts = [strategy: :one_for_one, name: Web.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
