import Config

config :web, Web.Endpoint, secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

config :publishing, Publishing.Repo,
  start_apps_before_migration: [:ssl],
  ssl: true,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :publishing, Publishing.Integration.Github, token: System.fetch_env!("GITHUB_API_TOKEN")

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_OAUTH_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_OAUTH_CLIENT_SECRET")
