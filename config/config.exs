use Mix.Config

config :enconta_test, cowboy_port: System.get_env("PORT") || 8080
