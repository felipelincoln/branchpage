defmodule Publishing.Markdown do
  @moduledoc """
  Module for handling raw markdown texts.
  """

  @preview_length Application.compile_env!(:publishing, :markdown)[:preview_length]
  @heading_length Application.compile_env!(:publishing, :markdown)[:heading_length]
  @heading_default Application.compile_env!(:publishing, :markdown)[:heading_default]

  @doc """
  Transform markdown into HMTL performing additional mutations.

  ## Features
  * Removes the first `#` heading
  * Add `language-none` to inline and code blocks.

  Example:
      iex> get_body("# title")
      ""

      iex> get_body("## title")
      "<h2>\\ntitle</h2>\\n"

      iex> get_body("`some code`")
      "<p>\\n<code class=\\"language-none\\">some code</code></p>\\n"

      iex> get_body("```\\nsome code\\n```")
      "<pre><code class=\\"language-none\\">some code</code></pre>\\n"
  """
  @spec get_body(String.t()) :: list
  def get_body(markdown) do
    markdown
    |> to_ast()
    |> remove_heading()
    |> add_code_class()
    |> Earmark.Transform.transform()
  end

  @doc """
  Returns the markdown's main title or the given `default` (optional).

  Examples:
      iex> get_heading("# Hello World!\\nLorem ipsum...")
      "Hello World!"

      iex> get_heading("Lorem ipsum dolor sit amet...", "Untitled")
      "Untitled"
  """
  @spec get_heading(String.t()) :: String.t()
  def get_heading(markdown, default \\ @heading_default) when is_binary(markdown) do
    with {:ok, ast, _} <- EarmarkParser.as_ast(markdown),
         [{"h1", _, [title], _} | _tail] when is_binary(title) <- ast do
      title
      |> String.slice(0, @heading_length)
      |> String.trim()
    else
      _ -> default
    end
  end

  def get_preview(markdown) do
    title_size =
      "# #{get_heading(markdown)}\n"
      |> byte_size

    preview_length = @preview_length + title_size

    if byte_size(markdown) > preview_length do
      markdown
      |> String.slice(0, preview_length)
      |> String.trim()
      |> Kernel.<>(" ...")
      |> get_body()
    else
      markdown
      |> String.trim()
      |> get_body()
    end
  end

  defp to_ast(markdown) do
    {:ok, ast, _} = EarmarkParser.as_ast(markdown, code_class_prefix: "language-")

    ast
  end

  defp remove_heading([{"h1", _, [_title], _} | tail]), do: tail
  defp remove_heading(ast), do: ast

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
