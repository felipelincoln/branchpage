defmodule Publishing.DataCase do
  @moduledoc """
  Module for tests requiring database integration
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox
  alias Publishing.Repo

  setup context do
    :ok = Sandbox.checkout(Repo)

    unless context[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    :ok
  end
end
