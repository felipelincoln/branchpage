defmodule Web.DashboardLive do
  @moduledoc false

  use Phoenix.LiveView

  alias Publishing.Interact
  alias Publishing.Manage

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

      articles_impressions = Interact.user_impressions_total(user)

      {graph_dates, graph_impressions} = build_graph_data(user)

      max_impressions =
        graph_impressions
        |> Map.merge(%{"threshold" => 100})
        |> Enum.max(fn {_key1, value1}, {_key2, value2} -> value1 > value2 end)
        |> elem(1)

      socket =
        socket
        |> assign(:meta, @meta)
        |> assign(:articles, articles)
        |> assign(:articles_count, articles_count)
        |> assign(:articles_impressions, articles_impressions)
        |> assign(:graph_date, Date.utc_today())
        |> assign(:hover_index, "27")
        |> assign(:graph_dates, graph_dates)
        |> assign(:graph_impressions, graph_impressions)
        |> assign(:graph_max_impressions, max_impressions)

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
        |> assign(:hover_index, "27")
        |> assign(:graph_dates, %{})
        |> assign(:graph_impressions, %{})
        |> assign(:graph_max_impressions, 1)

      {:ok, socket}
    end
  end

  @impl true
  def handle_event("get-graph-impressions", %{"barIndex" => hover_index}, socket) do
    socket =
      socket
      |> assign(:hover_index, hover_index)

    {:noreply, socket}
  end

  defp build_graph_data(user_id) do
    data =
      for days_ago <- 0..27 do
        key = Integer.to_string(27 - days_ago)

        date =
          Date.utc_today()
          |> Date.add(-days_ago)

        impressions = Interact.user_impressions_by_date(user_id, date)

        {key, date, impressions}
      end

    impressions_map =
      data
      |> Enum.map(fn {key, _, impr} -> {key, impr} end)
      |> Map.new()

    dates_map =
      data
      |> Enum.map(fn {key, date, _} -> {key, format_date(date)} end)
      |> Map.new()

    {dates_map, impressions_map}
  end
end
