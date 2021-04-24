defmodule Publishing.Integration.Github do
  @moduledoc """
  Integrates with github.
  """

  defstruct [:username, :repository, :resource]

  @type t :: %__MODULE__{username: binary, repository: binary, resource: binary}

  @doc """
  Returns the markdown's main title. It defaults to "Untitled".

  Examples:
      iex> title("# Hello World!\\nLorem ipsum...")
      "Hello World!"

      iex> title("Lorem ipsum dolor sit amet...")
      nil
  """
  @spec title(String.t()) :: String.t()
  def title(content) do
    with {:ok, ast, _} <- EarmarkParser.as_ast(content),
         [{"h1", _, [title], _} | _tail] <- ast do
      title
    else
      _ -> nil
    end
  end

  def validate(url) do
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

  def get_username(url), do: decompose(url).username

  def get_content(url) do
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
