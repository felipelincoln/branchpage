defmodule Web.ArticleLive do
  @moduledoc false

  use Phoenix.LiveView

  import Phoenix.HTML, only: [raw: 1]
  import Publishing.Helper, only: [format_date: 1]

  alias Publishing.Interact
  alias Publishing.Manage

  @meta %{
    title: "branchpage title",
    description: "no description yet",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(%{"username" => username, "article" => id}, _session, socket) do
    if connected?(socket) do
      article = Manage.load_article!(username, id)

      Interact.view(article.id)

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
    else
      socket =
        socket
        |> assign(:meta, @meta)
        |> assign(:name, "")
        |> assign(:username, "")
        |> assign(:article, %Manage.Article{})

      {:ok, socket}
    end
  end
end
