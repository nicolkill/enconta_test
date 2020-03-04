defmodule Enconta.TeamController do
  use Enconta, :controller

  alias Enconta.FootballTeam

  def calculate_players_payment(conn, %{"jugadores" => jugadores}) do
    response = FootballTeam.calculate_players_payment(jugadores)

    send_json(conn, %{data: response})
  end

end
