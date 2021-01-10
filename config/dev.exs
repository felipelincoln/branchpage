import Config

config :web, Web.Endpoint,
  http: [port: 4000],
  code_reloader: true,
  check_origin: false,
  live_reload: [
    patterns: [
      ~r"lib/web/templates/error/.*(eex)$"
    ]
  ]
