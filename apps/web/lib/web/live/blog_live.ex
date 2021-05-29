defmodule Web.BlogLive do
  @moduledoc false

  use Phoenix.LiveView

  alias Publishing.Manage

  import Phoenix.HTML, only: [raw: 1]
  import Publishing.Helper, only: [format_date: 1]

  @meta %{
    title: "branchpage title",
    description: "some description",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(%{"username" => username}, _session, socket) do
    blog = Manage.load_blog!(username)
    articles = blog.articles

    socket =
      socket
      |> assign(:meta, @meta)
      |> assign(:username, username)
      |> assign(:articles, articles)
      |> push_event("highlightAll", %{})

    {:ok, socket}
  end
end
