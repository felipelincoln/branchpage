defmodule Publishing do
  @moduledoc """
  Documentation for `Publishing`.
  """

  alias Publishing.Article
  alias Publishing.Integration
  alias Publishing.Repo

  def save_article(%Article{} = article) do
    attrs = Map.from_struct(article)

    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @spec build_article(String.t()) :: {:ok, %Article{}} | {:error, String.t()}
  def build_article(url) do
    with {:ok, _url} <- validate_url(url),
         {:ok, integration} <- Integration.service(url),
         {:ok, content} <- integration.get_content(url) do
      title =
        content
        |> integration.content_heading("Untitled")
        |> String.trim()
        |> String.slice(0, 255)

      {:ok, %Article{body: content, title: title, edit_url: url}}
    else
      {:error, :scheme} ->
        {:error, "Invalid scheme. Use http or https"}

      {:error, :extension} ->
        {:error, "Invalid extension. Must be .md"}

      {:error, :integration} ->
        {:error, "Not integrated with #{host(url)} yet."}

      {:error, 404} ->
        {:error, "Page not found"}

      {:error, status} when is_integer(status) ->
        {:error, "Failed to retrieve page content. (error #{status})"}
    end
  end

  defp host(url), do: URI.parse(url).host

  defp validate_url(url) do
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
