defmodule Web.ArticleLive do
  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]

  @meta %{
    title: "branchpage title",
    description: "some description",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(%{"username" => _username, "article" => _}, _session, socket) do
    name = "Felipe Lincoln"
    date = Timex.today() |> Timex.format!("%b %e", :strftime)
    title = "Lorem ipsum dolor sit amet. Consectetur adipiscing elit."
    body_html = "<p>iasjdiajdis</p><p>Life is waterfall</p>"

    socket =
      socket
      |> assign(@meta)
      |> assign(:name, name)
      |> assign(:date, date)
      |> assign(:title, title)
      |> assign(:body_html, body_html)

    {:ok, socket}
  end
end
