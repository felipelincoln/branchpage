import Config

config :web, Web.Endpoint,
  secret_key_base: get_or_raise("SECRET_KEY_BASE")

config :blog, Blog.Repo,
  start_apps_before_migration: [:ssl],
  ssl: true,
  url: get_or_raise("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

defp get_or_raise(env_var),
  do: System.get_env(env_var) || raise "Missing environment variable #{env_var}"
