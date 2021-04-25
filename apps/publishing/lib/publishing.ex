defmodule Publishing do
  @moduledoc """
  Documentation for `Publishing`.
  """

  alias Publishing.Article
  alias Publishing.Integration
  alias Publishing.Repo

  @spec create_article(String.t()) :: {:ok, %Article{}} | {:error, String.t()}
  def create_article(url) do
    with {:ok, integration} <- Integration.service(url),
         {:ok, _url} <- integration.validate(url),
         {:ok, _username} <- integration.get_username(url),
         {:ok, content} <- integration.get_content(url) do
      title =
        content
        |> integration.content_heading()
        |> String.trim()
        |> String.slice(0, 255)

      attrs = %{title: title, edit_url: url}

      %Article{body: content}
      |> Article.changeset(attrs)
      |> Repo.insert()
    else
      {:error, :integration} -> "Not integrated with #{host(url)} yet."
      {:error, :scheme} -> "Invalid scheme. Use http or https"
      {:error, :host} -> "Invalid host. Must be #{host(url)}"
      {:error, :extension} -> "Invalid extension. Must be .md"
      {:error, :username} -> "Invalid URL."
      {:error, 404} -> "Page not found."
      {:error, status} -> "Failed to retrieve page content. (error #{status})"
    end
  end

  defp host(url), do: URI.parse(url).host
end
