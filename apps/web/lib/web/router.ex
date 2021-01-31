defmodule Web.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_root_layout, {Web.LayoutView, :base}
  end

  scope "/", Web do
    pipe_through :browser

    live "/", HomeLive
  end
end
