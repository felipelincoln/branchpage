defmodule Publishing.ArticleTest do
  use ExUnit.Case, async: true

  import Publishing.ChangesetHelpers
  alias Publishing.Article

  @valid_empty_attrs %{}
  @valid_attrs %{title: "title", edit_url: "edit_url", blog_id: "blog_id"}
  @invalid_cast_attrs %{title: 0, edit_url: 0, blog_id: 0}
  @invalid_length_attrs %{title: long_string()}

  test "changeset/2 with valid empty params" do
    changeset = Article.changeset(%Article{}, @valid_empty_attrs)
    assert changeset.valid?
  end

  test "changeset/2 with valid params" do
    changeset = Article.changeset(%Article{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset/2 with invalid cast params" do
    changeset = Article.changeset(%Article{}, @invalid_cast_attrs)
    refute changeset.valid?

    assert %{title: [:cast]} = errors_on(changeset)
    assert %{edit_url: [:cast]} = errors_on(changeset)
    assert %{blog_id: [:cast]} = errors_on(changeset)
  end

  test "changeset/2 with invalid length params" do
    changeset = Article.changeset(%Article{}, @invalid_length_attrs)
    refute changeset.valid?

    assert %{title: [:length]} = errors_on(changeset)
  end
end
