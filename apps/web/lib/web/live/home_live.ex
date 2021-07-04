defmodule Web.HomeLive do
  @moduledoc false

  use Phoenix.LiveView

  alias Publishing.Manage
  alias Web.NewLive
  alias Web.Router.Helpers, as: Routes

  import Publishing.Helper, only: [format_date: 1]

  @meta %{
    title: "Branchpage",
    description:
      "Branchpage is an open source blogging platform where you can create a blog using GitHub markdown files.",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(_params, _session, socket) do
    {cursor, articles} = Manage.list_articles(limit: 3)

    socket =
      socket
      |> assign(:meta, @meta)
      |> assign(:articles, articles)
      |> assign(:cursor, cursor)

    {:ok, socket, temporary_assigns: [articles: []]}
  end

  @impl true
  def handle_event("go-preview", %{"url" => url}, socket) do
    path = Routes.live_path(socket, NewLive, url: url)

    {:noreply, redirect(socket, to: path)}
  end

  @impl true
  def handle_event("load-more", _params, socket) do
    %{assigns: %{cursor: start_cursor}} = socket

    {end_cursor, articles} = Manage.list_articles(limit: 3, cursor: start_cursor)

    socket =
      socket
      |> assign(:cursor, end_cursor)
      |> assign(:articles, articles)

    {:noreply, socket}
  end
end
