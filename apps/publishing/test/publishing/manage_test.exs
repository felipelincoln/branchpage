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
  @valid_html "<p>\nSome description</p>\n"
  @valid_preview "<p>\nSome ...</p>\n"

  @updated_body "# Updated document title\n\nTest"
  @updated_title "Updated document title"
  @updated_html "<p>\nTest</p>\n"
  @updated_preview "<p>\nTest</p>\n"

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
    expect(TeslaMock, :call, &api/2)

    assert {:error, "Page not found"} = Manage.build_article(@invalid_404_url)
  end

  test "build_article/1 on invalid url returns status code" do
    expect(TeslaMock, :call, &api/2)

    assert {:error, "Failed to retrieve page content. (error 500)"} =
             Manage.build_article(@invalid_500_url)
  end

  test "build_article/1 on valid url returns article" do
    expect(TeslaMock, :call, &api/2)

    assert {:ok, %Article{} = article} = Manage.build_article(@valid_url)

    assert article.url == @valid_url
    assert article.title == @valid_title
    assert article.body == @valid_html
    assert article.preview == @valid_preview
    assert article.blog == %Blog{username: @valid_username}
  end

  test "save_article/1 saves an article" do
    expect(TeslaMock, :call, &api/2)
    {:ok, %Article{} = article} = Manage.build_article(@valid_url)

    assert {:ok, %Article{}} = Manage.save_article(article)
  end

  test "save_article/1 on existing article returns error" do
    expect(TeslaMock, :call, &api/2)
    {:ok, %Article{} = article} = Manage.build_article(@valid_url)

    assert {:ok, %Article{}} = Manage.save_article(article)
    assert {:error, "This article has already been published!"} = Manage.save_article(article)
  end

  test "load_article!/2 loads an article from database" do
    expect(TeslaMock, :call, 2, &api/2)
    {:ok, %Article{} = article} = Manage.build_article(@valid_url)
    {:ok, %Article{id: id}} = Manage.save_article(article)

    assert (%Article{} = article) = Manage.load_article!(@valid_username, id)
    assert article.url == @valid_url
    assert article.title == @valid_title
    assert article.body == @valid_html
    assert article.preview == @valid_preview
    assert %Blog{username: @valid_username} = article.blog
  end

  test "load_article!/2 updates title and preview" do
    expect(TeslaMock, :call, &api/2)
    expect(TeslaMock, :call, &api_updated/2)

    {:ok, %Article{} = article} = Manage.build_article(@valid_url)
    {:ok, %Article{id: id}} = Manage.save_article(article)

    assert (%Article{} = article) = Manage.load_article!(@valid_username, id)
    assert article.url == @valid_url
    assert %Blog{username: @valid_username} = article.blog

    assert article.body == @updated_html
    assert article.title == @updated_title
    assert article.preview == @updated_preview
  end

  test "load_article!/2 deletes article if deleted from integration" do
    expect(TeslaMock, :call, &api/2)
    expect(TeslaMock, :call, &api_deleted/2)

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
    expect(TeslaMock, :call, 2, &api/2)
    {:ok, %Article{} = article} = Manage.build_article(@valid_url)
    {:ok, %Article{}} = Manage.save_article(article)

    assert_raise Publishing.PageNotFound, fn -> Manage.load_article!("invalid", "") end
  end

  test "get_blog!/1 on non existing username raises PageNotFound" do
    assert_raise Publishing.PageNotFound, fn -> Manage.get_blog!("") end
  end

  test "get_blog!/1 return blogs with preloaded articles" do
    blog = Factory.insert(:blog, username: "test")
    _articles = Factory.insert_pair(:article, blog_id: blog.id)

    assert (%Blog{} = blog) = Manage.get_blog!("test")
    assert [_, _] = blog.articles
  end

  defp api_deleted(%{url: @valid_raw_url}, _), do: {:ok, %{status: 404}}
  defp api_updated(%{url: @valid_raw_url}, _), do: {:ok, %{status: 200, body: @updated_body}}
  defp api(%{url: @valid_raw_url}, _), do: {:ok, %{status: 200, body: @valid_body}}
  defp api(%{url: @invalid_404_raw_url}, _), do: {:ok, %{status: 404}}
  defp api(%{url: @invalid_500_raw_url}, _), do: {:ok, %{status: 500}}
end
