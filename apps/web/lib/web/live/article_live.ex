defmodule Web.ArticleLive do
  @moduledoc false

  use Phoenix.LiveView

  import Phoenix.HTML, only: [raw: 1]
  import Publishing.Helper, only: [format_date: 1]

  alias Publishing.Manage

  @meta %{
    title: "branchpage title",
    description: "some description",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(%{"username" => _username, "article" => id}, _session, socket) do
    article = Manage.load_article!(id)

    name = "Felipe Lincoln"
    username = article.blog.username

    socket =
      socket
      |> assign(:meta, @meta)
      |> assign(:name, name)
      |> assign(:username, username)
      |> assign(:article, article)
      |> push_event("highlightAll", %{})

    {:ok, socket}
  end
end
