import Config

config :web, Web.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: System.get_env("HOST"), port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto], host: nil],
  cache_static_manifest: "priv/static/cache_manifest.json"
