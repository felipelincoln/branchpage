defmodule Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :web

  @session_options [
    store: :cookie,
    key: "_web_key",
    signing_salt: "KXBHqVtGsYq13l6OnbeU8RllO+S0xUQ+"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :web,
    gzip: true,
    only: ~w(css)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.CodeReloader
    plug Phoenix.LiveReloader
  end

  plug Web.Router
end
