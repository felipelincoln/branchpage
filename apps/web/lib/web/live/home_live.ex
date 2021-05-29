defmodule Web.HomeLive do
  @moduledoc false

  use Phoenix.LiveView

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

    {:ok, socket}
  end
end
