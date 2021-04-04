import Config

config :web, Web.Endpoint, http: [port: {:system, "PORT"}]
