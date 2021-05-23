defmodule Publishing.Integration.Github do
  @moduledoc """
  Integrates with github.
  """

  @behaviour Publishing.Integration

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
    case decompose(url) do
      [username, _] -> {:ok, username}
      [] -> {:error, :username}
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

    case Tesla.get(raw) do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status: code}} ->
        {:error, code}
    end
  end

  defp raw_url([username, resource]) do
    "https://raw.githubusercontent.com/#{username}/#{resource}"
  end

  defp raw_url(_), do: ""

  defp decompose(url) do
    with %URI{path: path} when is_binary(path) <- URI.parse(url),
         ["", username, repository, "blob" | tail] <- String.split(path, "/"),
         resource <- Enum.join([repository] ++ tail, "/"),
         true <- not_empty_string(username),
         true <- not_empty_string(resource) do
      [username, resource]
    else
      _ -> []
    end
  end

  defp not_empty_string(str), do: is_binary(str) and str != ""
end
