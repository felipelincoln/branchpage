defmodule Web.AuthController do
  use Phoenix.Controller

  alias Ueberauth.Strategy.Helpers

  plug Ueberauth

  def request(conn, _params) do
    render(conn, callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_auth: token}} = conn, _params) do
    IO.inspect(token, label: "token")

    redirect(conn, to: "/")
  end
end
