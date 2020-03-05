use Mix.Config

{port, _} = (System.get_env("PORT") || "4000") |> Integer.parse

config :enconta_test, cowboy_port: port
