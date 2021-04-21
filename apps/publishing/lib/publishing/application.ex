defmodule Publishing.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [Publishing.Repo]

    Supervisor.start_link(children, strategy: :one_for_one, name: Publishing.Supervisor)
  end
end
