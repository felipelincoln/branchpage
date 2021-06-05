defmodule Web.HomeLive do
  @moduledoc false

  use Phoenix.LiveView

  alias Web.NewLive
  alias Web.Router.Helpers, as: Routes

  import Publishing.Manage, only: [count_blogs: 0]

  @meta %{
    title: "branchpage title",
    description: "some description",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:meta, @meta)
      |> assign(:count_blogs, count_blogs())

    {:ok, socket}
  end

  @impl true
  def handle_event("go-preview", %{"url" => url}, socket) do
    path = Routes.live_path(socket, NewLive, url: url)

    {:noreply, push_redirect(socket, to: path)}
  end
end
