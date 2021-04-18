defmodule Blog.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :blog,
    adapter: Ecto.Adapters.Postgres
end
