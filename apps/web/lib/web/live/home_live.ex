defmodule Web.HomeLive do
  use Phoenix.LiveView

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :value, 0)}
  end

  @impl true
  def handle_event("increase", _value, socket) do
    value = socket.assigns.value
    {:noreply, assign(socket, :value, value + 1)}
  end
end
