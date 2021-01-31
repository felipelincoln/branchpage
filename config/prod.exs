import Config

config :web, Web.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("HOST")],
  cache_static_manifest: "priv/static/cache_manifest.json"
