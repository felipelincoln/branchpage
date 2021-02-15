defmodule Web.HomeLive do
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
      |> assign(@meta)
      |> assign(:value, 0)

    {:ok, socket}
  end

  @impl true
  def handle_event("increase", _value, socket) do
    value = socket.assigns.value
    {:noreply, assign(socket, :value, value + 1)}
  end
end
