defmodule Web.AuthController do
  use Phoenix.Controller

  alias Publishing.Manage
  alias Ueberauth.Strategy.Helpers

  import Plug.Conn

  plug Ueberauth

  def request(conn, _params) do
    render(conn, callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_auth: data}} = conn, %{"provider" => "github"}) do
    auth_info = data.info

    user_data = %{
      username: auth_info.nickname,
      fullname: auth_info.name,
      bio: auth_info.description,
      avatar_url: auth_info.urls.avatar_url
    }

    {:ok, blog} = Manage.get_or_create_blog(user_data, "github")

    conn
    |> put_session(:current_user, blog.id)
    |> redirect(to: "/")
  end
end
