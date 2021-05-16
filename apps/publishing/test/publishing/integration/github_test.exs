defmodule Publishing.Integration.GithubTest do
  use ExUnit.Case, async: true
  doctest Publishing.Integration.Github, import: true

  alias Publishing.Integration.Github
  alias Publishing.Tesla.Mock, as: TeslaMock

  import Mox

  @valid_url "https://github.com/felipelincoln/branchpage/blob/main/README.md"
  @valid_raw_url "https://raw.githubusercontent.com/felipelincoln/branchpage/main/README.md"
  @valid_body "# Documet title\n\nSome description"

  @invalid_url "https://github.com/"
  @invalid_raw_url "https://raw.githubusercontent.com///"

  test "get_content/1 on valid url returns content" do
    expect(TeslaMock, :call, &get_content/2)

    assert Github.get_content(@valid_url) == {:ok, @valid_body}
  end

  test "get_content/1 non existing url returns 404" do
    expect(TeslaMock, :call, &get_content/2)

    assert Github.get_content(@invalid_url) == {:error, 404}
  end

  defp get_content(%{url: @valid_raw_url}, _), do: {:ok, %{status: 200, body: @valid_body}}
  defp get_content(%{url: @invalid_raw_url}, _), do: {:ok, %{status: 404}}
end
