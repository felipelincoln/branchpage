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

IO.puts("on dev configs!")
