defmodule Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :web

  plug Web.Router

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.CodeReloader
    plug Phoenix.LiveReloader
  end
end
