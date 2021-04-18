defmodule Blog.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [Blog.Repo]

    Supervisor.start_link(children, strategy: :one_for_one, name: Blog.Supervisor)
  end
end
