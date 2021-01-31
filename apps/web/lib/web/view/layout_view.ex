defmodule Web.LayoutView do
  use Phoenix.View, root: "lib/web/templates", namespace: Web
  use Phoenix.HTML

  alias Web.Router.Helpers, as: Routes
end
