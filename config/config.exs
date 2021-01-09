import Config

config :phoenix, :json_library, Jason

config :web, Web.Endpoint,
  url: [host: "localhost"],
  http: [port: 4000],
  secret_key_base: "zliHduy02MJH71NcPjCEcVsr7cv/EEna3wSILC4XEU2mAya0tPOsdABKUx2Z5ph2",
  render_errors: [view: Web.ErrorView, accepts: ~w(html), layout: false]
