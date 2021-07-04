defmodule Publishing.Manage.ArticleTest do
  use ExUnit.Case, async: true

  import Publishing.ChangesetHelpers
  alias Publishing.Manage.Article

  @valid_empty_attrs %{title: "title", description: "desc", url: "some url"}
  @valid_attrs %{title: "title", description: "desc", url: "url", blog_id: "blog_id"}
  @invalid_cast_attrs %{title: 0, url: 0, blog_id: 0, description: 0}
  @invalid_length_attrs %{title: long_string(), description: long_string()}

  describe "changeset/2" do
    test "valid empty params" do
      changeset = Article.changeset(%Article{}, @valid_empty_attrs)
      assert changeset.valid?
    end

    test "valid params" do
      changeset = Article.changeset(%Article{}, @valid_attrs)
      assert changeset.valid?
    end

    test "invalid cast params" do
      changeset = Article.changeset(%Article{}, @invalid_cast_attrs)
      refute changeset.valid?

      assert %{title: [:cast]} = errors_on(changeset)
      assert %{description: [:cast]} = errors_on(changeset)
      assert %{url: [:cast]} = errors_on(changeset)
      assert %{blog_id: [:cast]} = errors_on(changeset)
    end

    test "invalid required params" do
      changeset = Article.changeset(%Article{}, %{})
      refute changeset.valid?

      assert %{title: [:required]} = errors_on(changeset)
      assert %{description: [:required]} = errors_on(changeset)
    end

    test "invalid length params" do
      changeset = Article.changeset(%Article{}, @invalid_length_attrs)
      refute changeset.valid?

      assert %{title: [:length]} = errors_on(changeset)
      assert %{description: [:length]} = errors_on(changeset)
    end
  end

  describe "get_error/1" do
    test "empty title returns error message" do
      invalid_required_title = %{@valid_attrs | title: ""}
      changeset = Article.changeset(%Article{}, invalid_required_title)
      refute changeset.valid?

      assert Article.get_error(changeset) =~ "Title"
    end

    test "long title returns error message" do
      invalid_required_title = %{@valid_attrs | title: long_string()}
      changeset = Article.changeset(%Article{}, invalid_required_title)
      refute changeset.valid?

      assert Article.get_error(changeset) =~ "Title"
    end

    test "empty description returns error message" do
      invalid_required_title = %{@valid_attrs | description: ""}
      changeset = Article.changeset(%Article{}, invalid_required_title)
      refute changeset.valid?

      assert Article.get_error(changeset) =~ "Description"
    end

    test "long description returns error message" do
      invalid_required_title = %{@valid_attrs | description: long_string()}
      changeset = Article.changeset(%Article{}, invalid_required_title)
      refute changeset.valid?

      assert Article.get_error(changeset) =~ "Description"
    end
  end
end
