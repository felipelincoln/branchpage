defmodule Publishing do
  @moduledoc """
  Documentation for `Publishing`.
  """

  alias Publishing.Article
  alias Publishing.Integration
  alias Publishing.Repo

  @spec build_article(String.t()) :: {:ok, %Article{}} | {:error, String.t()}
  def build_article(url) do
    with {:ok, _url} <- Integration.validate_url(url),
         {:ok, integration} <- Integration.service(url),
         {:ok, _username} <- integration.get_username(url),
         {:ok, content} <- integration.get_content(url) do
      title =
        content
        |> integration.content_heading("Untitled")
        |> String.trim()
        |> String.slice(0, 255)

      {:ok, %Article{body: content, title: title, edit_url: url}}
    else
      {:error, :integration} ->
        {:error, "Not integrated with #{host(url)} yet."}

      {:error, :scheme} ->
        {:error, "Invalid scheme. Use http or https"}

      {:error, :extension} ->
        {:error, "Invalid extension. Must be .md"}

      {:error, :username} ->
        {:error, "Invalid resource"}

      {:error, 404} ->
        {:error, "Page not found"}

      {:error, status} ->
        {:error, "Failed to retrieve page content. (error #{status})"}
    end
  end

  defp host(url), do: URI.parse(url).host
end
