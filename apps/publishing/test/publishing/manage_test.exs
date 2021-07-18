defmodule Publishing.ManageTest do
  use Publishing.DataCase

  alias Publishing.Factory
  alias Publishing.Manage
  alias Publishing.Manage.{Article, Blog}
  alias Publishing.Tesla.Mock, as: TeslaMock

  import Mox

  @valid_url "https://github.com/felipelincoln/branchpage/blob/main/README.md"
  @valid_raw_url "https://raw.githubusercontent.com/felipelincoln/branchpage/main/README.md"
  @valid_username "felipelincoln"
  @valid_body "# Document title\n\nSome description"
  @valid_title "Document title"
  @valid_html "<h1>\nDocument title</h1>\n<p>\nSome description</p>\n"

  @invalid_404_url "https://github.com/f/b/blob/repo/a.md"
  @invalid_404_raw_url "https://raw.githubusercontent.com/f/b/repo/a.md"
  @invalid_500_url "https://github.com/f/b/blob/repo/500.md"
  @invalid_500_raw_url "https://raw.githubusercontent.com/f/b/repo/500.md"

  test "build_article/1 on invalid url returns error tuple" do
    assert {:error, "Invalid scheme. Use http or https"} = Manage.build_article("")

    assert {:error, "Invalid extension. Must be .md"} = Manage.build_article("https://")

    assert {:error, "Not integrated with integration.com yet"} =
             Manage.build_article("https://integration.com/f/b/blob/b.md")

    assert {:error, "Invalid github.com resource"} =
             Manage.build_article("https://github.com/test.md")
  end

  test "build_article/1 non existing url returns 404" do
    expect(TeslaMock, :call, &raw/2)

    assert {:error, "Page not found"} = Manage.build_article(@invalid_404_url)
  end

  test "build_article/1 on invalid url returns status code" do
    expect(TeslaMock, :call, &raw/2)

    assert {:error, "Failed to retrieve page content. (error 500)"} =
             Manage.build_article(@invalid_500_url)
  end

  test "build_article/1 on valid url returns article" do
    expect(TeslaMock, :call, &raw/2)

    assert {:ok, %Article{} = article} = Manage.build_article(@valid_url)

    assert article.url == @valid_url
    assert article.title == @valid_title
    assert article.body == @valid_html
    assert article.blog == %Blog{username: @valid_username}
  end

  test "save_article/1 saves an article" do
    expect(TeslaMock, :call, &raw/2)
    {:ok, %Article{} = article} = Manage.build_article(@valid_url)

    assert {:ok, %Article{}} = Manage.save_article(article)
  end

  test "save_article/1 on existing article returns error" do
    expect(TeslaMock, :call, &raw/2)
    {:ok, %Article{} = article} = Manage.build_article(@valid_url)

    assert {:ok, %Article{}} = Manage.save_article(article)
    assert {:error, "This article has already been published."} = Manage.save_article(article)
  end

  test "load_article!/2 loads an article from database" do
    expect(TeslaMock, :call, 2, &raw/2)
    {:ok, %Article{} = article} = Manage.build_article(@valid_url)
    {:ok, %Article{id: id}} = Manage.save_article(article)

    assert (%Article{} = article) = Manage.load_article!(@valid_username, id)
    assert article.url == @valid_url
    assert article.title == @valid_title
    assert article.body == @valid_html
    assert %Blog{username: @valid_username} = article.blog
  end

  test "load_article!/2 deletes article if deleted from integration" do
    expect(TeslaMock, :call, &raw/2)
    expect(TeslaMock, :call, &raw_deleted/2)

    {:ok, %Article{} = article} = Manage.build_article(@valid_url)

    {:ok, %Article{id: id}} = Manage.save_article(article)

    assert %Article{} = Publishing.Repo.get(Article, id)
    assert_raise Publishing.PageNotFound, fn -> Manage.load_article!(@valid_username, id) end
    assert Publishing.Repo.get(Article, id) == nil
  end

  test "load_article!/2 on non existing article raises PageNotFound" do
    assert_raise Publishing.PageNotFound, fn -> Manage.load_article!(@valid_username, "") end
  end

  test "load_article!/2 on non matching username raises PageNotFound" do
    expect(TeslaMock, :call, 2, &raw/2)
    {:ok, %Article{} = article} = Manage.build_article(@valid_url)
    {:ok, %Article{}} = Manage.save_article(article)

    assert_raise Publishing.PageNotFound, fn -> Manage.load_article!("invalid", "") end
  end

  test "load_blog!/1 on non existing username raises PageNotFound" do
    assert_raise Publishing.PageNotFound, fn -> Manage.load_blog!("") end
  end

  test "load_blog!/1 return blogs with preloaded articles" do
    platform = Factory.insert(:platform, name: "https://github.com/")
    expect(TeslaMock, :call, &api/2)

    blog = Factory.insert(:blog, username: "test", platform_id: platform.id)
    _articles = Factory.insert_pair(:article, blog_id: blog.id)

    assert (%Blog{} = blog) = Manage.load_blog!("test")
    assert [_, _] = blog.articles
  end

  test "list_articles/0 returns nil cursor and empty list" do
    assert {nil, []} = Manage.list_articles()
  end

  test "list_articles/1 returns by default 10 latest articles" do
    inserted_at = DateTime.utc_now() |> DateTime.add(-60)
    _articles = Factory.insert_list(19, :article, inserted_at: inserted_at)

    assert {_cursor, articles} = Manage.list_articles()
    assert length(articles) == 10
  end

  test "list_articles/1 can set limit and cursor" do
    inserted_at = DateTime.utc_now() |> DateTime.add(-60)
    _articles = Factory.insert(:article, inserted_at: inserted_at)

    inserted_at = DateTime.utc_now() |> DateTime.add(-30)
    _articles = Factory.insert_list(2, :article, inserted_at: inserted_at)

    inserted_at = DateTime.utc_now() |> DateTime.add(-5)
    _articles = Factory.insert_list(2, :article, inserted_at: inserted_at)

    assert {cursor, [_, _]} = Manage.list_articles(limit: 2)
    assert {cursor, [_, _]} = Manage.list_articles(limit: 2, cursor: cursor)
    assert {_cursor, [_]} = Manage.list_articles(limit: 2, cursor: cursor)
    assert {nil, []}
  end

  test "get_or_create_blog/2 on non existing blog creates it" do
    attrs = %{username: "test"}

    assert is_nil(Publishing.Repo.get_by(Blog, username: "test"))
    assert {:ok, %Blog{}} = Manage.get_or_create_blog(attrs, "github")
  end

  test "get_or_create_blog/2 on existing blog gets it" do
    attrs = %{username: "test"}
    _blog = Factory.insert(:blog, attrs)

    assert %Blog{} = Publishing.Repo.get_by(Blog, username: "test")
    assert {:ok, %Blog{}} = Manage.get_or_create_blog(attrs, "github")
  end

  defp raw_deleted(%{url: @valid_raw_url}, _), do: {:ok, %{status: 404}}
  defp raw(%{url: @valid_raw_url}, _), do: {:ok, %{status: 200, body: @valid_body}}
  defp raw(%{url: @invalid_404_raw_url}, _), do: {:ok, %{status: 404}}
  defp raw(%{url: @invalid_500_raw_url}, _), do: {:ok, %{status: 500}}

  defp api(%{url: "https://api.github.com/graphql"}, _) do
    response = %{
      "data" => %{
        "user" => %{
          "name" => "as",
          "bio" => "as",
          "avatarUrl" => "adad"
        }
      }
    }

    {:ok, %{body: response, status: 200}}
  end
end
