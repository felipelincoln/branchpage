defmodule Publishing.Integration.Github do
  @moduledoc """
  Integrates with github markdown resources.
  """

  @doc """
  Returns the markdown's main title. It defaults to "Untitled".

  Examples:
      iex> title("# Hello World!\\nLorem ipsum...")
      "Hello World!"

      iex> title("Lorem ipsum dolor sit amet...")
      "Untitled"
  """
  @spec title(String.t()) :: String.t()
  def title(content) do
    with {:ok, ast, _} <- EarmarkParser.as_ast(content),
         [{"h1", _, [title], _} | _tail] <- ast do
      title
    else
      _ -> "Untitled"
    end
  end

  def author(url) do
    [username | _] = decompose(url)
    username
  end

  def get_content(url) do
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
