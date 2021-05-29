import Config

config :web, Web.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  live_reload: [
    patterns: [
      ~r"apps/web/lib/web/(live|view|templates)/.*(ex)$",
      ~r"apps/web/priv/static/(css|js)/.*(css|js)$",
      ~r"apps/web/priv/static/.*png$"
    ]
  ],
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch",
      cd: Path.expand("../apps/web/assets", __DIR__)
    ]
  ]

config :publishing, Publishing.Repo,
  username: "postgres",
  password: "postgres",
  database: "branchpage_dev",
  hostname: "db",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :publishing, Publishing.Integration.Github, token: System.get_env("GITHUB_API_KEY")
