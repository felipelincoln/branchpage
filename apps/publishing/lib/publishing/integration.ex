defmodule Publishing.Integration do
  @moduledoc """
  Integration
  """

  alias Publishing.Integration.Github

  def service(url) do
    case URI.parse(url) do
      %URI{host: "github.com"} -> {:ok, Github}
      _ -> {:error, :integration}
    end
  end

  @doc """
  Validates the `url` as a github markdown.

  Examples:
      iex> validate_url("https://github.com/felipelincoln/branchpage/blob/main/README.md")
      {:ok, "https://github.com/felipelincoln/branchpage/blob/main/README.md"}

      iex> validate_url("github.com/felipelincoln/branchpage/blob/main/README.md")
      {:error, :scheme}

      iex> validate_url("https://invalid.com/felipelincoln/branchpage/blob/main/README.md")
      {:error, :host}

      iex> validate_url("https://github.com/felipelincoln/branchpage/blob/main/README.txt")
      {:error, :extension}
  """
  @spec validate_url(String.t()) :: {:ok, String.t()} | {:error, atom}
  def validate_url(url) when is_binary(url) do
    case URI.parse(url) do
      %URI{scheme: scheme} when scheme not in ["http", "https"] ->
        {:error, :scheme}

      %URI{path: path} ->
        if MIME.from_path(path || "/") == "text/markdown",
          do: {:ok, url},
          else: {:error, :extension}
    end
  end
end
