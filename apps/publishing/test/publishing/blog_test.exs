defmodule Publishing.BlogTest do
  use ExUnit.Case, async: true

  alias Publishing.Blog

  @valid_empty_attrs %{}
  @valid_attrs %{
    fullname: "fullname",
    username: "username",
    bio: "bio",
    donate_url: "donate_url"
  }
  @invalid_attrs %{fullname: 0, username: 0, bio: 0, donate_url: 0}

  test "channgeset/2 with valid empty params" do
    changeset = Blog.changeset(%Blog{}, @valid_empty_attrs)
    assert changeset.valid?
  end

  test "channgeset/2 with valid params" do
    changeset = Blog.changeset(%Blog{}, @valid_attrs)
    assert changeset.valid?
  end

  test "channgeset/2 with invalid params" do
    changeset = Blog.changeset(%Blog{}, @invalid_attrs)
    refute changeset.valid?
  end
end
