import Config

config :web, Web.Endpoint,
  http: [port: 4000],
  debug_errors: false,
  code_reloader: true,
  check_origin: false,
  live_reload: [
    patterns: [
      ~r"apps/web/lib/web/templates/error/.*(eex)$",
      ~r"apps/web/priv/static/(css|js)/.*(css|js)$"
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
