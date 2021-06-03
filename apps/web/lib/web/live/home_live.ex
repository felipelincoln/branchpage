defmodule Web.HomeLive do
  @moduledoc false

  use Phoenix.LiveView

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
end
