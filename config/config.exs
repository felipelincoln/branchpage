import Config

config :phoenix, :json_library, Jason

config :web, Web.Endpoint,
  secret_key_base: "zliHduy02MJH71NcPjCEcVsr7cv/EEna3wSILC4XEU2mAya0tPOsdABKUx2Z5ph2",
  render_errors: [view: Web.ErrorView, accepts: ~w(html), layout: {Web.LayoutView, :base}],
  pubsub_server: Web.PubSub,
  live_view: [signing_salt: "nNxuMZr4Bq73HLMihu1pYEdtKLAL/f+Z"]

import_config "#{System.get_env("MIX_ENV", "dev")}.exs"
