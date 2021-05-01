defmodule Publishing.Manage.BlogTest do
  use ExUnit.Case, async: true

  import Publishing.ChangesetHelpers
  alias Publishing.Manage.Blog

  @valid_empty_attrs %{}
  @valid_attrs %{
    fullname: "fullname",
    username: "username",
    bio: "bio",
    donate_url: "donate_url"
  }
  @invalid_cast_attrs %{fullname: 0, username: 0, bio: 0, donate_url: 0}
  @invalid_length_attrs %{
    fullname: long_string(),
    username: long_string(),
    bio: long_string()
  }

  test "changeset/2 with valid empty params" do
    changeset = Blog.changeset(%Blog{}, @valid_empty_attrs)
    assert changeset.valid?
  end

  test "changeset/2 with valid params" do
    changeset = Blog.changeset(%Blog{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset/2 with invalid cast params" do
    changeset = Blog.changeset(%Blog{}, @invalid_cast_attrs)
    refute changeset.valid?

    assert %{fullname: [:cast]} = errors_on(changeset)
    assert %{username: [:cast]} = errors_on(changeset)
    assert %{bio: [:cast]} = errors_on(changeset)
  end

  test "changeset/2 with invalid length params" do
    changeset = Blog.changeset(%Blog{}, @invalid_length_attrs)
    refute changeset.valid?

    assert %{fullname: [:length]} = errors_on(changeset)
    assert %{username: [:length]} = errors_on(changeset)
    assert %{bio: [:length]} = errors_on(changeset)
  end
end
