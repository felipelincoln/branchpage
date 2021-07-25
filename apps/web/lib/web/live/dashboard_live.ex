defmodule Web.DashboardLive do
  @moduledoc false

  use Phoenix.LiveView

  @meta %{
    title: "branchpage title",
    description: "some description",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(_args, %{"current_user" => user}, socket) do
    socket =
      socket
      |> assign(:meta, @meta)

    {:ok, socket}
  end
end
