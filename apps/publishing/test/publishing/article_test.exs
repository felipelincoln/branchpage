defmodule Publishing.ArticleTest do
  use ExUnit.Case, async: true

  alias Publishing.Article

  @valid_empty_attrs %{}
  @valid_attrs %{article: "article", edit_url: "edit_url", blog_id: "blog_id"}
  @invalid_attrs %{article: 0, edit_url: 0}

  test "channgeset/2 with valid empty params" do
    changeset = Article.changeset(%Article{}, @valid_empty_attrs)
    assert changeset.valid?
  end

  test "channgeset/2 with valid params" do
    changeset = Article.changeset(%Article{}, @valid_attrs)
    assert changeset.valid?
  end

  test "channgeset/2 with invalid params" do
    changeset = Article.changeset(%Article{}, @invalid_attrs)
    refute changeset.valid?
  end
end
