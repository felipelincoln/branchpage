defmodule Web.DashboardLive do
  @moduledoc false

  use Phoenix.LiveView

  alias Publishing.Manage

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

      articles_impressions =
        Enum.reduce(articles, 0, fn %{impressions_total: total}, acc -> acc + total end)

      socket =
        socket
        |> assign(:meta, @meta)
        |> assign(:articles, articles)
        |> assign(:articles_count, articles_count)
        |> assign(:articles_impressions, articles_impressions)

      {:ok, socket}
    else
      socket =
        socket
        |> assign(:meta, @meta)
        |> assign(:articles, [])
        |> assign(:articles_count, 0)
        |> assign(:articles_impressions, 0)

      {:ok, socket}
    end
  end
end
