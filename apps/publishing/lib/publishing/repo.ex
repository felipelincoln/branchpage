defmodule Publishing.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :publishing,
    adapter: Ecto.Adapters.Postgres
end
