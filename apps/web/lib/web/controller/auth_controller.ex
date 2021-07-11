defmodule Web.AuthController do
  use Phoenix.Controller

  alias Ueberauth.Strategy.Helpers

  import Plug.Conn

  plug Ueberauth

  def request(conn, _params) do
    render(conn, callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_auth: _token}} = conn, _params) do
    conn
    |> put_session(:current_user, "felipe")
    |> redirect(to: "/")
  end
end
