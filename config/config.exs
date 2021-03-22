use Mix.Config

config :backdoor,
  connect_host: {127, 0 ,0 ,1},
  connect_port: 3434,
  listen_port: 3535

config :logger, level: :info
