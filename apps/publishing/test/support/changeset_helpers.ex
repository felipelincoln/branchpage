defmodule Publishing.ChangesetHelpers do
  @moduledoc """
  Helpers for testing ecto changesets.
  """

  @doc """
  Transforms changeset errors into a map of validation keys.
  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(
      changeset,
      fn {_msg, opts} -> opts[:validation] end
    )
  end

  @doc """
  Generate a 256 byte sized string.
  """
  def long_string, do: String.duplicate("a", 256)
end
