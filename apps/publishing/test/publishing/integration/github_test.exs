defmodule Publishing.Integration.GithubTest do
  use ExUnit.Case, async: true
  doctest Publishing.Integration.Github, import: true

  @valid_url "https://github.com/felipelincoln/branchpage/blob/main/README.md"
  @invalid_url "https://github.com/felipelincoln/branchpage/blob/main/404"

  test "get_content/1 on valid url returns content" do
  end

  test "get_content/1 on invalid url returns error" do
  end
end
