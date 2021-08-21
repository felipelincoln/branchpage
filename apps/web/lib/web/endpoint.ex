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
    only: ~w(css js images favicon.png)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.Session, @session_options
  plug Web.Router
end
