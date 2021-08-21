defmodule Web.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router
  import Plug.Conn

  pipeline :browser do
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_root_layout, {Web.LayoutView, :base}
  end

  pipeline :auth do
    plug :authenticated_or_404
  end

  def authenticated_or_404(conn, _options) do
    case get_session(conn) do
      %{"current_user" => _user} -> conn
      _session -> raise Publishing.PageNotFound
    end
  end

  scope "/dashboard", Web do
    pipe_through [:browser, :authenticated_or_404]

    live "/", DashboardLive
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
