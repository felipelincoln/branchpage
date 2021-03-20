defmodule Web.ErrorView do
  use Phoenix.View, root: "lib/web/templates", namespace: Web
  use Phoenix.HTML

  alias Web.Router.Helpers, as: Routes

  def render("404.html", assigns) do
    meta = %{
      title: "404 error",
      description: "page not found!"
    }

    assigns
    |> Map.merge(meta)
    |> layout()
  end

  defp layout(assigns) do
    ~E"""
    <!doctype html>
    <html lang="en">
      <head>
        <title><%= @title %></title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
        <meta name="theme-color" content="#4285f4">
        <meta name="description" content="Page not found">
        <meta property="og:url" content="https://branchpage-homologation.herokuapp.com">
        <meta property="og:title" content="Page not found">
        <meta property="og:image" content="/images/cover.png">
        <meta property="og:description" content="page not found">
        <meta property="og:site_name" content="Branchpage">
        <meta property="og:image:width" content="1200">
        <meta property="og:image:height" content="630">
        <meta property="og:type" content="website">
        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:url" content="https://branchpage-homologation.herokuapp.com">
        <meta name="twitter:title" content="page not found">
        <meta name="twitter:description" content="page not found">
        <meta name="twitter:image" content="/images/cover.png">
        <link rel="stylesheet" href='<%= Routes.static_path(@conn, "/css/base.css") %>'>
        <link rel="icon" type="image/png" href="/favicon.png">
      </head>
      <body>
        <nav class="flex items-center justify-between">
          <a href="#">Felipe Lincoln</a>
          <a href="#">Start a blog</a>
        </nav>
        <main class="container max-w-screen-sm">
        404!
        </main>
      </body>
    </html>
    """
  end
end
