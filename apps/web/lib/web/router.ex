defmodule Web.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_root_layout, {Web.LayoutView, :base}
  end

  scope "/auth", Web do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", Web do
    pipe_through :browser

    live "/", HomeLive
    live "/new", NewLive
    live "/:username", BlogLive
    live "/:username/:article", ArticleLive
  end
end
