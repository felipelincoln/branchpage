defmodule Web.AuthController do
  use Phoenix.Controller

  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_auth: token}} = conn, _params) do
    IO.inspect(token, label: "token")

    redirect(conn, "/")
  end
end
