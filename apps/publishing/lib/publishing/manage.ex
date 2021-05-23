defmodule Publishing.Manage do
  @moduledoc """
  Manage's public API.
  """

  alias Publishing.Integration
  alias Publishing.Manage.{Article, Blog}
  alias Publishing.Manage.Markdown
  alias Publishing.Repo

  import Ecto.Query

  @doc """
  Loads an article from database.
  """
  @spec load_article!(any) :: Article.t()
  def load_article!(id) do
    db_article =
      Article
      |> Repo.get!(id)
      |> Repo.preload(:blog)

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

  @doc """
  Saves an article struct to the database.
  """
  @spec save_article(Article.t()) :: {:ok, Article.t()} | {:error, String.t()}
  def save_article(%Article{} = article) do
    {:ok, blog} = upsert_blog(article.blog.username)

    attrs =
      article
      |> Map.from_struct()
      |> Map.merge(%{blog_id: blog.id})

    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:error, changeset} ->
        {:error, Article.get_error(changeset)}

      {:ok, %Article{}} = success ->
        success
    end
  end

  @doc """
  Build an article struct from the given `url`.
  """
  @spec build_article(String.t()) :: {:ok, Article.t()} | {:error, String.t()}
  def build_article(url) do
    with url <- String.trim(url),
         {:ok, _url} <- validate_url(url),
         {:ok, integration} <- Integration.service(url),
         {:ok, username} <- integration.get_username(url),
         {:ok, content} <- integration.get_content(url) do
      title =
        content
        |> integration.content_heading("Untitled")
        |> String.trim()
        |> String.slice(0, 255)

      html = Markdown.parse(content)

      blog = %Blog{username: username}

      {:ok, %Article{body: html, title: title, url: url, blog: blog}}
    else
      {:error, :scheme} ->
        {:error, "Invalid scheme. Use http or https"}

      {:error, :extension} ->
        {:error, "Invalid extension. Must be .md"}

      {:error, :integration} ->
        {:error, "Not integrated with #{host(url)} yet"}

      {:error, 404} ->
        {:error, "Page not found"}

      {:error, status} when is_integer(status) ->
        {:error, "Failed to retrieve page content. (error #{status})"}
    end
  end

  defp upsert_blog(username) do
    case Repo.one(from Blog, where: [username: ^username]) do
      nil ->
        attrs = %{username: username}

        %Blog{}
        |> Blog.changeset(attrs)
        |> Repo.insert()

      blog ->
        {:ok, blog}
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
