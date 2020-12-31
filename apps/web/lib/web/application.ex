defmodule Web.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Web, options: [port: application_port()]}
    ]

    opts = [strategy: :one_for_one, name: Web.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp application_port do
    System.get_env("PORT", "4000")
    |> String.to_integer()
  end
end
