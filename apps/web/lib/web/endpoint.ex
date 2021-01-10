defmodule Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :web

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Web.Router
end
