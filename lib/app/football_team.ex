defmodule Enconta.FootballTeam do

  alias Enconta.Model.Player

  @doc """
  Transforma el row data a la estructura manejable Player
  """
  def data_to_players(data) do
    players = Enum.map(data, &Player.map_to_player/1)

    {:ok, players}
  rescue
    e -> {:error, e}
  end

  @doc """
  Agrega el promedio de equipo a cada jugador del equipo
  """
  def add_team_average(players) do
    players = players
    |> Enum.group_by(&(&1.equipo))
    |> Map.values
    |> Enum.map(fn players ->
      sumatoria = Enum.reduce(players, 0, fn player, sum -> Player.get_average(player) + sum end)

      Enum.map(players, fn player ->
        Player.add_team_average(player, sumatoria / length(players))
      end)
    end)
    |> Enum.concat

    {:ok, players}
  rescue
    e -> {:error, e}
  end

  @doc """
  Transforma la data de Players a simple row data
  """
  def transform_to_row_data(players) do
    data = Enum.map(players, fn player -> player |> Player.calculate_salary |> Player.to_row_data end)

    {:ok, data}
  rescue
    e -> {:error, e}
  end

  @doc """
  Calcula los salarios de un arreglo de jugadores

  Estos se segmentan por el campo "equipo" y a partir de ahi se calculan los salarios
  """
  def calculate_players_payment(data) do
    with {:ok, players} <- data_to_players(data),
         {:ok, players} <- add_team_average(players),
         {:ok, data} <- transform_to_row_data(players) do
      {:ok, data}
    end
  end

end
