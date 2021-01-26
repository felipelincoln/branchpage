defmodule Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :web

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
