import Config

config :web, Web.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE") || raise("SECRET_KEY_BASE is missing.")

config :publishing, Publishing.Repo,
  start_apps_before_migration: [:ssl],
  ssl: true,
  url: System.get_env("DATABASE_URL") || raise("DATABASE_URL is missing."),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :publishing, Publishing.Integration.Github,
  token: System.get_env("GITHUB_API_KEY") || raise("GITHUB_API_KEY is missing.")
