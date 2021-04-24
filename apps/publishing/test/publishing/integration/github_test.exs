defmodule Publishing.Integration.GithubTest do
  use ExUnit.Case, async: true
  doctest Publishing.Integration.Github, import: true

  alias Publishing.Integration.Github

  test "validate/1 on url with invalid scheme" do
    assert {:error, :scheme} = Github.validate("")
    assert {:error, :scheme} = Github.validate("test.com/")
  end

  test "validate/1 on url with invalid host" do
    assert {:error, :host} = Github.validate("https://test.com")
    assert {:error, :host} = Github.validate("http://test.com")
  end

  test "validate/1 on url with invalid resource extension" do
    assert {:error, :extension} = Github.validate("https://github.com/test.txt")
    assert {:error, :extension} = Github.validate("http://github.com/test.js")
  end

  test "validate/1 on valid url" do
    assert {:ok, _url} = Github.validate("https://github.com/test.md")
    assert {:ok, _url} = Github.validate("http://github.com/test.md")
  end
end
