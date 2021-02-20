import Config

config :web, Web.Endpoint,
  http: [port: {:system, "PORT"}],
  url: nil,
  force_ssl: [rewrite_on: [:x_forwarded_proto], host: nil],
  cache_static_manifest: "priv/static/cache_manifest.json"
