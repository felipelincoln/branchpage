defmodule Web.ArticleLive do
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
  def mount(%{"username" => _username, "article" => id}, _session, socket) do
    article = Manage.load_article(id)

    name = "Felipe Lincoln"

    socket =
      socket
      |> assign(:meta, @meta)
      |> assign(:name, name)
      |> assign(:article, article)

    {:ok, socket}
  end
end
