defmodule Publishing.Integration.Github do
  @moduledoc """
  Integrates with github.
  """

  defstruct [:username, :repository, :resource]

  @doc """
  Validates the `url` as a github markdown.

  Examples:
      iex> validate("https://github.com/felipelincoln/branchpage/blob/main/README.md")
      {:ok, "https://github.com/felipelincoln/branchpage/blob/main/README.md"}

      iex> validate("github.com/felipelincoln/branchpage/blob/main/README.md")
      {:error, :scheme}

      iex> validate("https://invalid.com/felipelincoln/branchpage/blob/main/README.md")
      {:error, :host}

      iex> validate("https://github.com/felipelincoln/branchpage/blob/main/README.txt")
      {:error, :extension}
  """
  @spec validate(String.t()) :: {:ok, String.t()} | {:error, atom}
  def validate(url) when is_binary(url) do
    case URI.parse(url) do
      %URI{scheme: scheme} when scheme not in ["http", "https"] ->
        {:error, :scheme}

      %URI{host: host} when host != "github.com" ->
        {:error, :host}

      %URI{path: path} ->
        if MIME.from_path(path) == "text/markdown",
          do: {:ok, url},
          else: {:error, :extension}
    end
  end

  @doc """
  Returns the markdown's main title if there is one.

  Examples:
      iex> content_title("# Hello World!\\nLorem ipsum...")
      "Hello World!"

      iex> content_title("Lorem ipsum dolor sit amet...")
      nil
  """
  @spec content_title(String.t()) :: String.t() | nil
  def content_title(content) when is_binary(content) do
    with {:ok, ast, _} <- EarmarkParser.as_ast(content),
         [{"h1", _, [title], _} | _tail] <- ast do
      title
    else
      _ -> nil
    end
  end

  @doc """
  Returns the GitHub username from the `url`.

  Examples:
      iex> get_username("https://github.com/felipelincoln/branchpage/blob/main/README.md")
      "felipelincoln"

      iex> get_username("https://github.com/")
      nil
  """
  @spec get_username(String.t()) :: String.t() | nil
  def get_username(url) when is_binary(url), do: decompose(url).username

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
