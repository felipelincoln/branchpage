defmodule Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :web

  plug Web.Router
end
