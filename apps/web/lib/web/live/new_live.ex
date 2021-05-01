defmodule Web.NewLive do
  @moduledoc false

  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]

  alias Publishing.Manage

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
      |> assign(:validation, nil)
      |> assign(:article, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("preview", %{"url" => ""}, socket) do
    socket =
      socket
      |> assign(:validation, nil)
      |> assign(:article, nil)

    {:noreply, socket}
  end

  @impl true
  def handle_event("preview", %{"url" => url}, socket) do
    case Manage.build_article(url) do
      {:ok, article} ->
        socket =
          socket
          |> assign(:validation, nil)
          |> assign(:article, article)

        {:noreply, socket}

      {:error, validation} ->
        socket =
          socket
          |> assign(:validation, validation)
          |> assign(:article, nil)

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("publish", _params, %{assigns: %{article: nil}} = socket),
    do: {:noreply, socket}

  @impl true
  def handle_event("publish", _params, socket) do
    case Manage.save_article(socket.assigns.article) do
      {:ok, _article} ->
        # redirect
        {:noreply, socket}
    end
  end
end
