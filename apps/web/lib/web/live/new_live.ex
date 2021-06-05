defmodule Web.NewLive do
  @moduledoc false

  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]

  alias Publishing.Manage
  alias Web.ArticleLive
  alias Web.Router.Helpers, as: Routes

  @meta %{
    title: "branchpage title",
    description: "some description",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(params, _session, socket) do
    url = Map.get(params, "url")

    if url, do: send(self(), :preview)

    socket =
      socket
      |> assign(:meta, @meta)
      |> assign(:validation, nil)
      |> assign(:error, nil)
      |> assign(:article, nil)
      |> assign(:loading, false)
      |> assign(:url, url || "")

    {:ok, socket}
  end

  @impl true
  def handle_info(:preview, socket) do
    url = socket.assigns.url

    case Manage.build_article(url) do
      {:ok, article} ->
        socket =
          socket
          |> assign(:article, article)
          |> assign(:loading, false)
          |> push_event("highlightAll", %{})

        {:noreply, socket}

      {:error, validation} ->
        socket =
          socket
          |> assign(:validation, validation)
          |> assign(:loading, false)

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("preview", %{"url" => ""}, socket) do
    socket =
      socket
      |> assign(:validation, nil)
      |> assign(:error, nil)
      |> assign(:article, nil)

    {:noreply, socket}
  end

  @impl true
  def handle_event("preview", %{"url" => url}, socket) do
    send(self(), :preview)

    socket =
      socket
      |> assign(:validation, nil)
      |> assign(:error, nil)
      |> assign(:article, nil)
      |> assign(:loading, true)
      |> assign(:url, url)

    {:noreply, socket}
  end

  @impl true
  def handle_event("publish", _params, %{assigns: %{article: nil}} = socket),
    do: {:noreply, socket}

  @impl true
  def handle_event("publish", _params, socket) do
    case Manage.save_article(socket.assigns.article) do
      {:ok, article} ->
        username = socket.assigns.article.blog.username
        path = Routes.live_path(socket, ArticleLive, username, article.id)

        {:noreply, push_redirect(socket, to: path)}

      {:error, reason} ->
        {:noreply, assign(socket, :error, reason)}
    end
  end

  @impl true
  def handle_event("clear-flash", _params, socket) do
    socket =
      socket
      |> assign(:error, nil)

    {:noreply, socket}
  end
end
