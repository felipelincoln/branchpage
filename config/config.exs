import Config

config :phoenix, :json_library, Jason

config :web, Web.Endpoint,
  secret_key_base: "zliHduy02MJH71NcPjCEcVsr7cv/EEna3wSILC4XEU2mAya0tPOsdABKUx2Z5ph2",
  render_errors: [view: Web.ErrorView, accepts: ~w(html)],
  pubsub_server: Web.PubSub,
  live_view: [signing_salt: "nNxuMZr4Bq73HLMihu1pYEdtKLAL/f+Z"]

config :publishing,
  ecto_repos: [Publishing.Repo]

config :publishing, Publishing.Repo, migration_timestamps: [type: :utc_datetime]

config :publishing, :markdown,
  preview_length: 120,
  heading_length: 255,
  heading_default: "Untitled"

import_config "#{Mix.env()}.exs"
