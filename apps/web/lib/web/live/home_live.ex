defmodule Web.HomeLive do
  @moduledoc false

  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]

  @meta %{
    title: "branchpage title",
    description: "some description",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(_params, _session, socket) do
    articles = [
      %{
        title: "Lorem ipsum dolor sit amet. Consectetur adipiscing elit.",
        date: Timex.today() |> Timex.format!("%b %e", :strftime),
        body_html: """
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ornare eu mi eget lacinia. Maecenas tincidunt risus vel mi vehicula, sit amet varius ligula porta. Pellentesque id ex viverra, pellentesque neque eget, aliquet magna. Sed viverra egestas pulvinar. Mauris luctus egestas ante, et facilisis ligula vulputate.</p>
        <br>
        <img src="https://www.bretfisher.com/content/images/2019/11/C4-promo-with-title.png">
        <br>
        """
      },
      %{
        title: "Consectetur adipiscing elit.",
        date: Timex.today() |> Timex.format!("%b %e", :strftime),
        body_html: """
        """
      }
    ]

    socket =
      socket
      |> assign(:meta, @meta)
      |> assign(:articles, articles)

    {:ok, socket}
  end
end
