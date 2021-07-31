defmodule Web.ArticleLive do
  @moduledoc false

  use Phoenix.LiveView

  import Phoenix.HTML, only: [raw: 1]
  import Publishing.Helper, only: [format_date: 1]

  alias Publishing.Manage
  alias Publishing.Interact

  @meta %{
    title: "branchpage title",
    description: "no description yet",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(%{"username" => username, "article" => id}, _session, socket) do
    article = Manage.load_article!(username, id)

    if connected?(socket) do
      Interact.view(article.id)
      IO.puts "###############################"
    end

    meta = %{@meta | title: "#{article.title} – Branchpage"}
    name = article.blog.fullname || username

    socket =
      socket
      |> assign(:meta, meta)
      |> assign(:name, name)
      |> assign(:username, username)
      |> assign(:article, article)
      |> push_event("highlightAll", %{})

    {:ok, socket}
  end
end
