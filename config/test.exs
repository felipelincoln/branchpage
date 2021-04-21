import Config

config :web, Web.Endpoint, http: [port: 4000]

config :blog, Blog.Repo,
  username: "postgres",
  password: "postgres",
  database: "branchpage_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox
