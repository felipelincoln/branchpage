import Config

config :web, Web.Endpoint,
  http: [port: 4000],
  code_reloader: true,
  live_reload: [
    patterns: [
      ~r"lib/web/templates/.*(eex)$"
    ]
  ]
