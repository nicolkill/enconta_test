defmodule Enconta.Application do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Enconta.Router, options: [port: cowboy_port()]}
    ]
    opts = [strategy: :one_for_one, name: Enconta.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.get_env(:enconta_test, :cowboy_port, 8080)

end