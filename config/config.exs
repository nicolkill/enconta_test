use Mix.Config

:ets.new(:routes, [:set, :public, :named_table])

config :enconta_test, cowboy_port: 4000
