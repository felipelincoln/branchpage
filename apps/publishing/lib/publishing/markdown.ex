defmodule Publishing.Markdown do
  @moduledoc """
  Module for handling raw markdown texts.
  """

  @heading_tags ["h1", "h2", "h3", "h4", "h5", "h6"]
  @heading_default "Untitled"
  @description_default ""
  @cover_default ""

  @doc """
  Transform markdown into HMTL performing additional mutations.

  ## Features
  * Add `language-none` to inline and code blocks.

  Example:
      iex> parse("# title")
      "<h1>\\ntitle</h1>\\n"

      iex> parse("## title")
      "<h2>\\ntitle</h2>\\n"

      iex> parse("`some code`")
      "<p>\\n<code class=\\"language-none\\">some code</code></p>\\n"

      iex> parse("```\\nsome code\\n```")
      "<pre><code class=\\"language-none\\">some code</code></pre>\\n"

      iex> parse("```elixir\\nsome code\\n```")
      "<pre><code class=\\"elixir language-elixir\\">some code</code></pre>\\n"
  """
  @spec parse(String.t()) :: list
  def parse(markdown) do
    markdown
    |> to_ast()
    |> add_code_class()
    |> Earmark.Transform.transform()
  end

  @doc """
  Returns the markdown's title or first subtitle or the given `default` (optional).

  Examples:
      iex> get_title("# Hello World!\\nLorem ipsum...")
      "Hello World!"

      iex> get_title("## Hello World!\\nLorem ipsum...")
      "Hello World!"

      iex> get_title("Lorem ipsum dolor sit amet...", "Untitled")
      "Untitled"
  """
  @spec get_title(String.t()) :: String.t()
  def get_title(markdown, default \\ @heading_default) when is_binary(markdown) do
    get_content(markdown, default, &title_tags/1)
  end

  @doc """
  Returns the markdown's first paragraph or the given `default` (optional).

  Examples:
      iex> get_description("# Hello World!\\nLorem ipsum...")
      "Lorem ipsum..."

      iex> get_description("## Hello World!", "Untitled")
      "Untitled"
  """
  @spec get_description(String.t()) :: String.t()
  def get_description(markdown, default \\ @description_default) when is_binary(markdown) do
    get_content(markdown, default, &paragraph_tag/1)
  end

  @doc """
  Returns the markdown's first image or the given `default` (optional).

  Examples:
      iex> get_cover("# Hello World!\\n![](image.png)")
      "image.png"

      iex> get_cover("## Hello World!", "img.png")
      "img.png"
  """
  def get_cover(markdown, default \\ @cover_default) when is_binary(markdown) do
    get_content(markdown, default, &image_tag/1)
  end

  defp get_content(markdown, default, tag_function) do
    markdown
    |> to_ast()
    |> Enum.find(tag_function)
    |> tag_content_or_default(default)
  end

  defp title_tags({tag, _, [content], _}) when tag in @heading_tags and is_binary(content),
    do: true

  defp title_tags(_), do: false

  defp paragraph_tag({"p", _, [content], _}) when is_binary(content), do: true
  defp paragraph_tag(_), do: false

  defp image_tag({"img", _, _, _}), do: true
  defp image_tag({"p", _, [{"img", _, _, _}], _}), do: true
  defp image_tag(_), do: false

  defp tag_content_or_default({"p", _, [{"img", _, _, _} = img], _}, default) do
    tag_content_or_default(img, default)
  end

  defp tag_content_or_default({"img", attrs, _, _}, _default) do
    %{"src" => src} = Map.new(attrs)

    src
  end

  defp tag_content_or_default({_, _, [content], _}, _default), do: content
  defp tag_content_or_default(_, default), do: default

  defp to_ast(markdown) do
    {:ok, ast, _} = EarmarkParser.as_ast(markdown, code_class_prefix: "language-")

    ast
  end

  defp add_code_class(ast) do
    Earmark.Transform.map_ast(ast, fn
      {"code", [], [content], %{}} ->
        {"code", [{"class", "language-none"}], [content], %{}}

      {"code", [{"class", "inline"}], [content], %{}} ->
        {"code", [{"class", "language-none"}], [content], %{}}

      tag ->
        tag
    end)
  end
end
