import Config

config :web, Web.Endpoint,
  http: [port: {:system, "PORT"}],
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_origin: ["//branchpage.com"]

config :logger, level: :info
