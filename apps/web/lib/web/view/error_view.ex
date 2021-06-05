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
        <meta property="og:url" content="https://branchpage.com">
        <meta property="og:title" content="Page not found">
        <meta property="og:image" content="/images/cover.png">
        <meta property="og:description" content="page not found">
        <meta property="og:site_name" content="Branchpage">
        <meta property="og:image:width" content="1200">
        <meta property="og:image:height" content="630">
        <meta property="og:type" content="website">
        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:url" content="https://branchpage.com">
        <meta name="twitter:title" content="page not found">
        <meta name="twitter:description" content="page not found">
        <meta name="twitter:image" content="/images/cover.png">
        <link rel="stylesheet" href='<%= Routes.static_path(@conn, "/css/base.css") %>'>
        <link rel="icon" type="image/png" href="/favicon.png">
        <link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,300;0,400;0,700;0,900;1,300;1,400;1,700;1,900&display=swap" rel="stylesheet">
      </head>
      <body class="h-screen flex flex-col justify-between">
        <nav class="navbar">
          <a href="/" class="font-bold border-2 border-gray-800 px-1" aria-label="Branchpage">bp</a>
          <div>
          </div>
        </nav>
        <main class="container text-center">
          <h1 class="font-black text-8xl">404</h1>
        </main>
        <footer class="p-5 sm:p-8 mt-5 sm:mt-8">
          <a class="text-gray-400" href="/">Branchpage</a>
        </footer>
      </body>
    </html>
    """
  end
end
