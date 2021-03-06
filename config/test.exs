import Config

config :web, Web.Endpoint, http: [port: 4000]

config :publishing, Publishing.Repo,
  username: "postgres",
  password: "postgres",
  database: "branchpage_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn

config :tesla, adapter: Publishing.Tesla.Mock

config :publishing, :markdown, preview_length: 5
