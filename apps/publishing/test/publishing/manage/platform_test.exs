defmodule Publishing.Manage.PlatformTest do
  use Publishing.DataCase

  alias Publishing.Factory
  alias Publishing.Manage.Platform
  alias Publishing.Repo

  import Publishing.ChangesetHelpers

  @valid_empty_attrs %{}
  @valid_attrs %{name: "test-name"}
  @invalid_cast_attrs %{name: 0}

  test "changeset/2 with valid empty params" do
    changeset = Platform.changeset(%Platform{}, @valid_empty_attrs)
    assert changeset.valid?
  end

  test "changeset/2 with valid params" do
    changeset = Platform.changeset(%Platform{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset/2 with invalid cast params" do
    changeset = Platform.changeset(%Platform{}, @invalid_cast_attrs)
    refute changeset.valid?

    assert %{name: [:cast]} = errors_on(changeset)
  end

  test "changeset/2 with existing platform returns error on insert" do
    _ = Factory.insert(:platform, name: "platform")

    {:error, changeset} =
      %Platform{}
      |> Platform.changeset(%{name: "platform"})
      |> Repo.insert()

    assert %{name: [nil]} = errors_on(changeset)
  end
end
