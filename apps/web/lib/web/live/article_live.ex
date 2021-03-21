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

    body_html = """
    <img src="https://www.bretfisher.com/content/images/2019/11/C4-promo-with-title.png">
    <br>
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ornare eu mi eget lacinia. Maecenas tincidunt risus vel mi vehicula, sit amet varius ligula porta. Pellentesque id ex viverra, pellentesque neque eget, aliquet magna. Sed viverra egestas pulvinar. Mauris luctus egestas ante, et facilisis ligula vulputate sit amet. Nunc ut ipsum velit. Vivamus finibus scelerisque nibh, ac dapibus mauris finibus ut. Sed consequat nibh at pharetra ornare.</p>
    <p>Vivamus nunc dui, pellentesque quis nulla vel, laoreet facilisis sem. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Duis libero nibh, varius ac lacus nec, gravida facilisis mi. Mauris urna libero, laoreet sit amet gravida ac, pharetra eu magna. Morbi iaculis egestas interdum. Donec a mi sit amet ipsum consequat malesuada. Nam magna erat, tempus eget tortor nec, fringilla tincidunt odio. Mauris finibus eget mi vitae aliquet. Maecenas a est vitae urna vestibulum vulputate id at urna. Donec id feugiat orci, vel tincidunt nunc. Quisque dapibus libero porta fringilla consectetur.</p>
    <p>Aenean nunc augue, bibendum vitae aliquet sed, rhoncus at mauris. Morbi eleifend ultrices commodo. Donec bibendum justo a ultricies vehicula. Sed iaculis enim et nisl auctor, nec ultricies tortor suscipit. Phasellus non convallis dui. Nullam scelerisque quis tortor nec sollicitudin. Pellentesque tristique pretium nunc a tincidunt. Fusce sodales nunc sapien, at scelerisque diam fermentum sit amet. Fusce eu arcu magna. Curabitur ullamcorper elementum nisi vitae efficitur. Curabitur in venenatis magna. Fusce suscipit ex lectus, at iaculis est efficitur nec. Cras vitae dolor placerat, placerat sapien sit amet, tempor magna. Fusce sagittis leo sit amet magna venenatis fringilla. Phasellus euismod purus ex, quis egestas odio elementum sed.</p>
    <p>Suspendisse semper diam sit amet enim placerat, nec suscipit dolor efficitur. Suspendisse nec erat vitae felis dignissim rhoncus porta sit amet ipsum. Quisque consequat leo nec est hendrerit aliquet. Donec accumsan sem ut sapien placerat facilisis. Sed pharetra efficitur mi, quis condimentum ipsum egestas quis. Duis ultrices, nibh ut placerat tincidunt, elit dolor tincidunt orci, id ornare metus urna accumsan ex. Duis quis ullamcorper ex, blandit sagittis metus. Quisque urna mi, condimentum quis tortor non, maximus maximus felis. Suspendisse accumsan augue purus, ut pharetra nunc congue at.</p>
    <p>Fusce sit amet euismod arcu. In hac habitasse platea dictumst. Morbi non ullamcorper turpis. Curabitur rutrum venenatis nisl, sit amet pharetra erat rhoncus non. Suspendisse et arcu vitae eros bibendum porta convallis vel dolor. Maecenas eget sodales ex. Vestibulum feugiat purus vitae risus ultrices, sed vehicula justo posuere. Nulla commodo, elit sed tincidunt facilisis, nunc nunc posuere ligula, bibendum auctor mi ante et augue. Pellentesque finibus facilisis ex, eget volutpat turpis aliquet ac. Nullam lectus erat, finibus sed purus eu, maximus commodo enim. Curabitur tincidunt justo nec justo laoreet sodales vitae a nibh.</p>
    """

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
