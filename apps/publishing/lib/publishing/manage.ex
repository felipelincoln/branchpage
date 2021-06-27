defmodule Publishing.Manage do
  @moduledoc """
  Manage's public API.
  """

  alias Publishing.Integration
  alias Publishing.Manage.{Article, Blog, Platform}
  alias Publishing.Markdown
  alias Publishing.Repo

  import Ecto.Query

  def count_blogs do
    Repo.aggregate(Blog, :count, :id)
  end

  def load_blog!(username) do
    db_blog =
      Blog
      |> Repo.get_by!(username: username)
      |> Repo.preload([:articles, :platform])

    blog = build_blog(db_blog)

    content = %{
      fullname: blog.fullname,
      bio: blog.bio,
      avatar_url: blog.avatar_url
    }

    {:ok, _} =
      db_blog
      |> Blog.changeset(content)
      |> Repo.update()

    Map.merge(db_blog, content)
  rescue
    _error ->
      reraise Publishing.PageNotFound, __STACKTRACE__
  end

  defp build_blog(%Blog{} = blog) do
    %{username: username, platform: %{name: platform}} = blog

    {:ok, integration} = Integration.service(platform)
    {:ok, content} = integration.get_blog_data(username)

    %Blog{}
    |> Map.merge(content)
  end

  @doc """
  Loads an article from database.
  """
  @spec load_article!(String.t(), any) :: Article.t()
  def load_article!(username, id) do
    db_article =
      Article
      |> Repo.get!(id)
      |> Repo.preload(:blog)

    ^username = db_article.blog.username

    {:ok, article} =
      with {:error, _} <- build_article(db_article.url) do
        Repo.delete(db_article)

        :fail
      end

    content = %{
      title: article.title,
      body: article.body
    }

    {:ok, _} =
      db_article
      |> Article.changeset(content)
      |> Repo.update()

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
    {:ok, blog} = upsert_blog(article)

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
      title = Markdown.get_title(content)
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

      {:error, :username} ->
        {:error, "Invalid #{host(url)} resource"}

      {:error, 404} ->
        {:error, "Page not found"}

      {:error, status} when is_integer(status) ->
        {:error, "Failed to retrieve page content. (error #{status})"}
    end
  end

  defp get_platform(url) do
    url
    |> URI.parse()
    |> Map.merge(%{path: "/"})
    |> URI.to_string()
    |> upsert_platform!()
  end

  defp upsert_platform!(name) do
    platform = Repo.get_by(Platform, name: name)

    case platform do
      nil ->
        %Platform{}
        |> Platform.changeset(%{name: name})
        |> Repo.insert!()

      item ->
        item
    end
  end

  defp upsert_blog(%Article{} = article) do
    %{url: url, blog: %{username: username}} = article
    platform = get_platform(url)

    case Repo.one(from Blog, where: [username: ^username]) do
      nil ->
        attrs = %{username: username, platform_id: platform.id}

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
