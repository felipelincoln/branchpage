defmodule Web.DashboardArticleLive do
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
  def mount(%{"article" => article_id}, %{"current_user" => user}, socket) do
    if connected?(socket) do
      article = Manage.article_by_blog(article_id, user) |> IO.inspect

      {graph_dates, graph_impressions} = build_graph_data(article)

      max_impressions =
        graph_impressions
        |> Map.merge(%{"threshold" => 100})
        |> Enum.max(fn {_key1, value1}, {_key2, value2} -> value1 > value2 end)
        |> elem(1)

      socket =
        socket
        |> assign(:meta, @meta)
        |> assign(:graph_date, Date.utc_today())
        |> assign(:hover_index, "27")
        |> assign(:article, article)
        |> assign(:impressions_total, article.impressions_total)
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
        |> assign(:impressions_total, 0)
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

  defp build_graph_data(article_id) do
    data =
      for days_ago <- 0..27 do
        key = Integer.to_string(27 - days_ago)

        date =
          Date.utc_today()
          |> Date.add(-days_ago)

        impressions = Interact.impressions_by_date(article_id, date)

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
