defmodule Web.NewLive do
  @moduledoc false

  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]

  alias Publishing.Integration.Github

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

  @impl true
  def handle_event("preview", %{"url" => url}, socket) do
    IO.puts("In development")

    {:noreply, socket}
  end
end
