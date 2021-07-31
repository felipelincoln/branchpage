defmodule Web.BlogLive do
  @moduledoc false

  use Phoenix.LiveView

  alias Publishing.Manage

  # import Phoenix.HTML, only: [raw: 1]
  import Publishing.Helper, only: [format_date: 1]

  @meta %{
    title: "branchpage title",
    description: "some description",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(%{"username" => username}, _session, socket) do
    IO.puts "blog -----------------------------------------------------------------------------------"
    blog = Manage.load_blog!(username)
    articles = blog.articles
    meta = %{@meta | title: "#{username} – Branchpage"}

    socket =
      socket
      |> assign(:meta, meta)
      |> assign(:blog, blog)
      |> assign(:articles, articles)

    {:ok, socket}
  end
end
