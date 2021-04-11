defmodule Web.SearchLive do
  @moduledoc false

  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]

  @meta %{
    title: "branchpage title",
    description: "some description",
    social_image: "/images/cover.png"
  }

  @impl true
  def mount(params, _session, socket) do
    q = Map.get(params, "q")

    articles = [
      %{
        title: "Lorem ipsum dolor sit amet. Consectetur adipiscing elit.",
        date: Timex.today() |> Timex.format!("%b %e", :strftime),
        body_html: """
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ornare eu mi eget lacinia. Maecenas tincidunt risus vel mi vehicula, sit amet varius ligula porta. Pellentesque id ex viverra, pellentesque neque eget, aliquet magna. Sed viverra egestas pulvinar. Mauris luctus egestas ante, et facilisis ligula vulputate sit amet. Nunc ut ipsum velit. Vivamus finibus scelerisque nibh, ac dapibus mauris finibus ut. Sed consequat nibh at pharetra ornare.</p>
        <p>Vivamus nunc dui, pellentesque quis nulla vel, laoreet facilisis sem. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Duis libero nibh, varius ac lacus nec, gravida facilisis mi. Mauris urna libero, laoreet sit amet gravida ac, pharetra eu magna. Morbi iaculis egestas interdum. Donec a mi sit amet ipsum consequat malesuada. Nam magna erat, tempus eget tortor nec, fringilla tincidunt odio. Mauris finibus eget mi vitae aliquet. Maecenas a est vitae urna vestibulum vulputate id at urna. Donec id feugiat orci, vel tincidunt nunc. Quisque dapibus libero porta fringilla consectetur.</p>
        <p>Aenean nunc augue, bibendum vitae aliquet sed, rhoncus at mauris. Morbi eleifend ultrices commodo. Donec bibendum justo a ultricies vehicula. Sed iaculis enim et nisl auctor, nec ultricies tortor suscipit. Phasellus non convallis dui. Nullam scelerisque quis tortor nec sollicitudin. Pellentesque tristique pretium nunc a tincidunt. Fusce sodales nunc sapien, at scelerisque diam fermentum sit amet. Fusce eu arcu magna. Curabitur ullamcorper elementum nisi vitae efficitur. Curabitur in venenatis magna. Fusce suscipit ex lectus, at iaculis est efficitur nec. Cras vitae dolor placerat, placerat sapien sit amet, tempor magna. Fusce sagittis leo sit amet magna venenatis fringilla. Phasellus euismod purus ex, quis egestas odio elementum sed.</p>
        """
      },
      %{
        title: "Consectetur adipiscing elit.",
        date: Timex.today() |> Timex.format!("%b %e", :strftime),
        body_html: """
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ornare eu mi eget lacinia. Maecenas tincidunt risus vel mi vehicula, sit amet varius ligula porta. Pellentesque id ex viverra, pellentesque neque eget, aliquet magna. Sed viverra egestas pulvinar. Mauris luctus egestas ante, et facilisis ligula vulputate sit amet. Nunc ut ipsum velit. Vivamus finibus scelerisque nibh, ac dapibus mauris finibus ut. Sed consequat nibh at pharetra ornare.</p>
        <p>Vivamus nunc dui, pellentesque quis nulla vel, laoreet facilisis sem. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Duis libero nibh, varius ac lacus nec, gravida facilisis mi. Mauris urna libero, laoreet sit amet gravida ac, pharetra eu magna. Morbi iaculis egestas interdum. Donec a mi sit amet ipsum consequat malesuada. Nam magna erat, tempus eget tortor nec, fringilla tincidunt odio. Mauris finibus eget mi vitae aliquet. Maecenas a est vitae urna vestibulum vulputate id at urna. Donec id feugiat orci, vel tincidunt nunc. Quisque dapibus libero porta fringilla consectetur.</p>
        <p>Aenean nunc augue, bibendum vitae aliquet sed, rhoncus at mauris. Morbi eleifend ultrices commodo. Donec bibendum justo a ultricies vehicula. Sed iaculis enim et nisl auctor, nec ultricies tortor suscipit. Phasellus non convallis dui. Nullam scelerisque quis tortor nec sollicitudin. Pellentesque tristique pretium nunc a tincidunt. Fusce sodales nunc sapien, at scelerisque diam fermentum sit amet. Fusce eu arcu magna. Curabitur ullamcorper elementum nisi vitae efficitur. Curabitur in venenatis magna. Fusce suscipit ex lectus, at iaculis est efficitur nec. Cras vitae dolor placerat, placerat sapien sit amet, tempor magna. Fusce sagittis leo sit amet magna venenatis fringilla. Phasellus euismod purus ex, quis egestas odio elementum sed.</p>
        """
      }
    ]

    socket =
      socket
      |> assign(@meta)
      |> assign(:q, q)
      |> assign(:articles, articles)

    {:ok, socket}
  end
end
