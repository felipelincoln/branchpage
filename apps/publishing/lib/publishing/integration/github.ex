defmodule Publishing.Integration.Github do
  @moduledoc """
  implement a integration interface
  """

  def to_raw(url) do
    [username, repository, "blob" | tail] = decompose(url)
    resource = Enum.join(tail, "/")

    "https://raw.githubusercontent.com/#{username}/#{repository}/#{resource}"
  end

  def get_username(url) do
    [username | _] = decompose(url)

    username
  end

  defp decompose(url) do
    [_, path] = String.split(url, "github.com/")
    String.split(path, "/")
  end
end
