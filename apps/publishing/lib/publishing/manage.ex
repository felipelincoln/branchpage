defmodule Publishing.Manage do
  @moduledoc """
  Manage's public API.
  """

  alias Publishing.Integration
  alias Publishing.Manage.Article
  alias Publishing.Repo

  def load_article!(id) do
    db_article = Repo.get!(Article, id)
    {:ok, article} = build_article(db_article.url)
    date = Timex.format!(db_article.inserted_at, "%b %e", :strftime)

    content = %{
      title: article.title,
      body: article.body,
      inserted_at: date
    }

    Map.merge(db_article, content)
  rescue
    _error ->
      reraise Publishing.PageNotFound, __STACKTRACE__
  end

  @spec save_article(Article.t()) :: {:ok, Article.t()} | {:error, String.t()}
  def save_article(%Article{} = article) do
    attrs = Map.from_struct(article)

    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:error, changeset} ->
        {:error, Article.get_error(changeset)}

      success ->
        success
    end
  end

  @spec build_article(String.t()) :: {:ok, Article.t()} | {:error, String.t()}
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

      html =
        content
        |> ast_no_heading
        |> Earmark.Transform.transform()

      {:ok, %Article{body: html, title: title, url: url}}
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

  defp ast_no_heading(markdown) do
    with {:ok, ast, _} <- EarmarkParser.as_ast(markdown, code_class_prefix: "language-"),
         [{"h1", _, [_title], _} | tail] <- ast do
      tail
    else
      ast -> ast
    end
  end
end
