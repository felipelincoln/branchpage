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
    {_cursor, articles} = Manage.list_articles(limit: 3)

    socket =
      socket
      |> assign(:meta, @meta)
      |> assign(:articles, articles)

    {:ok, socket}
  end

  @impl true
  def handle_event("go-preview", %{"url" => url}, socket) do
    path = Routes.live_path(socket, NewLive, url: url)

    {:noreply, redirect(socket, to: path)}
  end
end
