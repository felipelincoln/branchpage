defmodule Publishing.Integration.Github do
  @moduledoc """
  Integrates with github.
  """

  defstruct [:username, :repository, :resource]

  @doc """
  Returns the markdown's main title if there is one.

  Examples:
      iex> content_heading("# Hello World!\\nLorem ipsum...")
      "Hello World!"

      iex> content_heading("Lorem ipsum dolor sit amet...")
      nil
  """
  @spec content_heading(String.t()) :: String.t() | nil
  def content_heading(content, default \\ "") when is_binary(content) do
    with {:ok, ast, _} <- EarmarkParser.as_ast(content),
         [{"h1", _, [title], _} | _tail] <- ast do
      title
    else
      _ -> default
    end
  end

  @doc """
  Returns the GitHub username from the `url`.

  Examples:
      iex> get_username("https://github.com/felipelincoln/branchpage/blob/main/README.md")
      {:ok, "felipelincoln"}

      iex> get_username("https://github.com/")
      {:error, :username}
  """
  @spec get_username(String.t()) :: {:ok, String.t()} | {:error, :username}
  def get_username(url) when is_binary(url) do
    case decompose(url).username do
      nil -> {:error, :username}
      u -> {:ok, u}
    end
  end

  @doc """
  Retrieve the raw content of a resource's `url` from github.
  """
  @spec get_content(String.t()) :: {:ok, Stream.t()} | {:error, integer}
  def get_content(url) when is_binary(url) do
    raw =
      url
      |> decompose()
      |> raw_url()

    case :hackney.get(raw) do
      {:ok, 200, _, ref} ->
        :hackney.body(ref)

      {:ok, status_code, _, _} ->
        {:error, status_code}
    end
  end

  defp raw_url(%__MODULE__{} = gh) do
    "https://raw.githubusercontent.com/#{gh.username}/#{gh.repository}/#{gh.resource}"
  end

  defp decompose(url) do
    with %URI{path: <<path::binary>>} <- URI.parse(url),
         ["", username, repository, "blob" | tail] <- String.split(path, "/"),
         resource <- Enum.join(tail, "/") do
      %__MODULE__{username: username, repository: repository, resource: resource}
    else
      _ -> %__MODULE__{}
    end
  end
end
