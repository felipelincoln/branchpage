defmodule Web.NewLive do
  @moduledoc false

  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]

  alias Publishing.Manage
  alias Web.ArticleLive
  alias Web.Router.Helpers, as: Routes

  @meta %{
    title: "Preview – Branchpage",
    description: "",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(params, _session, socket) do
    url = Map.get(params, "url")
    backref = Map.get(params, "backref")

    if connected?(socket) and url, do: send(self(), :preview)

    socket =
      socket
      |> assign(:meta, @meta)
      |> assign(:validation, nil)
      |> assign(:error, nil)
      |> assign(:article, nil)
      |> assign(:article_form, %{})
      |> assign(:loading, false)
      |> assign(:url, url || "")
      |> assign(:backref, backref || "/")
      |> assign(:tab, "form")

    {:ok, socket}
  end

  @impl true
  def handle_info(:preview, socket) do
    url = socket.assigns.url

    case Manage.build_article(url) do
      {:ok, article} ->
        article_form = %{
          title: article.title,
          cover: article.cover,
          description: article.description
        }

        socket =
          socket
          |> assign(:article, article)
          |> assign(:article_form, article_form)
          |> assign(:loading, false)

        {:noreply, socket}

      {:error, validation} ->
        socket =
          socket
          |> assign(:article, nil)
          |> assign(:article_form, %{})
          |> assign(:validation, validation)
          |> assign(:loading, false)

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("change-tab", %{"tab" => tab}, socket) do
    socket =
      socket
      |> assign(:tab, tab)
      |> assign(:error, nil)
      |> push_event("highlightAll", %{})

    {:noreply, socket}
  end

  @impl true
  def handle_event("preview", %{"url" => ""}, socket) do
    socket =
      socket
      |> assign(:validation, nil)
      |> assign(:error, nil)
      |> assign(:article, nil)
      |> assign(:article_form, %{})
      |> assign(:url, "")

    {:noreply, socket}
  end

  @impl true
  def handle_event("preview", %{"url" => url}, socket) do
    send(self(), :preview)

    socket =
      socket
      |> assign(:validation, nil)
      |> assign(:error, nil)
      |> assign(:loading, true)
      |> assign(:url, url)

    {:noreply, socket}
  end

  @impl true
  def handle_event("update", _params, %{assigns: %{article: nil}} = socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("update", %{"field" => field, "value" => value}, socket) do
    field_atom = String.to_existing_atom(field)

    article_form =
      socket.assigns.article_form
      |> Map.put(field_atom, value)

    socket =
      socket
      |> assign(:article_form, article_form)

    {:noreply, socket}
  end

  @impl true
  def handle_event("update", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("publish", _params, %{assigns: %{article: nil}} = socket),
    do: {:noreply, socket}

  @impl true
  def handle_event("publish", _params, %{assigns: assigns} = socket) do
    article = Map.merge(assigns.article, assigns.article_form)

    case Manage.save_article(article) do
      {:ok, saved_article} ->
        username = article.blog.username
        path = Routes.live_path(socket, ArticleLive, username, saved_article.id)

        {:noreply, redirect(socket, to: path)}

      {:error, reason} ->
        socket =
          socket
          |> assign(:error, reason)
          |> push_event("scrollTop", %{})

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("clear-alert", _params, socket) do
    socket =
      socket
      |> assign(:error, nil)

    {:noreply, socket}
  end
end
