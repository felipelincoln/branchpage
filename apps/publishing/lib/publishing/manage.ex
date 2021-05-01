defmodule Publishing.Manage do
  @moduledoc """
  Manage's public API.
  """

  alias Publishing.Integration
  alias Publishing.Manage.Article
  alias Publishing.Repo

  def save_article(%Article{} = article) do
    attrs = Map.from_struct(article)

    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @spec build_article(String.t()) :: {:ok, %Article{}} | {:error, String.t()}
  def build_article(url) do
    with url <- String.trim(url),
         {:ok, _url} <- validate_url(url),
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

  @doc """
  Prints a message relative to the first error in the `changeset`.
  """
  def get_error(%Ecto.Changeset{errors: [{error, _reason} | _tail]}) do
    case error do
      :edit_url ->
        "This article has already been published!"

      _ ->
        get_error([])
    end
  end

  def get_error(_) do
    """
    A problem ocurred validating your article.<br>
    Please contact the support.
    """
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
