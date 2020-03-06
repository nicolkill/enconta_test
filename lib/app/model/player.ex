defmodule Enconta.Model.Player do

  alias Enconta.Model.Player

  @enforce_keys [:nombre, :goles_minimos, :goles, :sueldo, :bono, :equipo]
  defstruct @enforce_keys ++ [:sueldo_completo, :promedio_equipo]

  @levels %{
    "A" => 5,
    "B" => 10,
    "C" => 15,
    "Cuauh" => 20
  }

  def map_to_player(%{"nombre" => nombre, "nivel" => nivel, "goles" => goles, "sueldo" => sueldo, "bono" => bono, "equipo" => equipo}) do
    goles_minimos = Map.get(@levels, nivel)

    %Player{
      nombre: nombre,
      goles_minimos: goles_minimos,
      goles: goles,
      sueldo: sueldo,
      bono: bono,
      sueldo_completo: nil,
      equipo: equipo
    }
  end

  def add_team_average(%Player{} = player, promedio_equipo) do
    %Player{player | promedio_equipo: promedio_equipo}
  end

  def get_average(%Player{} = player), do: player.goles / player.goles_minimos

  def calculate_salary(%Player{bono: bono, sueldo: sueldo, promedio_equipo: promedio_equipo} = player) do
    promedio = get_average(player)
    sueldo_completo = (bono * ((promedio_equipo + promedio) / 2)) + sueldo
    |> Float.round(4)

    %Player{player | sueldo_completo: sueldo_completo}
  end

  def to_row_data(%Player{} = player) do
    player
    |> Map.from_struct
    |> Map.delete(:promedio_equipo)
  end

end
