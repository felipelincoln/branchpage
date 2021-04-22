defmodule Publishing.Integration.Github do
  @moduledoc """
  implement a integration interface
  """

  def get_username(url) do
    [username | _] = decompose(url)
    username
  end

  def get_title(body) do
    {:ok, ast, _} = EarmarkParser.as_ast(body)

    default = {"h1", [], "Untitled", %{}}

    {"h1", _, title, _} = Enum.find(ast, default, fn {tag, _, _, _} -> tag == "h1" end)

    title
  end

  def get_body(url) do
    {:ok, 200, _, ref} =
      url
      |> to_raw()
      |> :hackney.get()

    {:ok, body} = :hackney.body(ref)

    body
  end

  defp to_raw(url) do
    [username, repository, "blob" | tail] = decompose(url)
    resource = Enum.join(tail, "/")

    "https://raw.githubusercontent.com/#{username}/#{repository}/#{resource}"
  end

  defp decompose(url) do
    [_, path] = String.split(url, "github.com/")
    String.split(path, "/")
  end
end
