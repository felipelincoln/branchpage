defmodule Web.DashboardLive do
  @moduledoc false

  use Phoenix.LiveView

  alias Publishing.Manage
  alias Publishing.Interact

  import Publishing.Helper, only: [format_date: 1]

  @meta %{
    title: "branchpage title",
    description: "some description",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(_args, %{"current_user" => user}, socket) do
    if connected?(socket) do
      articles = Manage.articles_by_blog(user)
      articles_count = length(articles)

      articles_impressions = Interact.user_impressions_by_date(user, Date.utc_today())

      socket =
        socket
        |> assign(:meta, @meta)
        |> assign(:articles, articles)
        |> assign(:articles_count, articles_count)
        |> assign(:articles_impressions, articles_impressions)
        |> assign(:graph_impressions, articles_impressions)
        |> assign(:graph_date, Date.utc_today())

      {:ok, socket}
    else
      socket =
        socket
        |> assign(:meta, @meta)
        |> assign(:articles, [])
        |> assign(:articles_count, 0)
        |> assign(:articles_impressions, 0)
        |> assign(:graph_impressions, 0)
        |> assign(:graph_date, Date.utc_today())

      {:ok, socket}
    end
  end
end
