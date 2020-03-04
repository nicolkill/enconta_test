use Mix.Config

:ets.new(:routes, [:set, :public, :named_table, read_concurrency: true])

{port, _} = (System.get_env("PORT") || "4000") |> Integer.parse

config :enconta_test, cowboy_port: port
