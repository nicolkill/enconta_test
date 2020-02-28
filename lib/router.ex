defmodule Enconta.Router do
  use Plug.Router

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason
  plug Plug.MethodOverride
  plug Plug.Head
  plug :match
  plug :dispatch

  post "/calculate_players_payment" do
    response = conn.body_params["jugadores"]
    |> Enconta.calculate_players_payment

    response = %{data: response}
    |> Jason.encode!

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, response)
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
