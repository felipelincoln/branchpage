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

  def get_title(body) do
    body
  end

  def get_body(raw_url) do
    {:ok, 200, _, ref} = :hackney.get(raw_url)
    {:ok, body} = :hackney.body(ref)

    body
  end

  defp decompose(url) do
    [_, path] = String.split(url, "github.com/")
    String.split(path, "/")
  end
end
