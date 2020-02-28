defmodule Enconta do

  @levels %{
    "A" => 5,
    "B" => 10,
    "C" => 15,
    "Cuauh" => 20
  }

  defp add_level(player, data) do
    %{"nivel" => level, "goles" => goles} = player
    goles_minimos = Map.get(@levels, level)

    player = Map.put(player, "goles_minimos", goles_minimos)
    |> Map.put("promedio", goles / goles_minimos)
    |> Map.delete("nivel")

    data ++ [player]
  end

  defp add_team_average(data) do
    sumatoria = Enum.reduce(data, 0, &(&1["promedio"] + &2))

    Enum.reduce(data, [], fn player, acc ->
      prom = sumatoria / length(data)
      player = Map.put(player, "promedio_equipo", prom)

      acc ++ [player]
    end)
  end

  defp add_salary(player, data) do
    %{"bono" => bono, "promedio" => promedio, "promedio_equipo" => promedio_equipo} = player

    sueldo_completo = bono * ((promedio_equipo + promedio) / 2)
    |> Float.round(4)

    player = Map.put(player, "sueldo_completo", sueldo_completo)
    |> Map.delete("promedio")
    |> Map.delete("promedio_equipo")

    data ++ [player]
  end

  @doc """
  Hello world.

  ## Examples

      iex> Enconta.calculate_players_payment([])
      []

  """
  def calculate_players_payment(data) do
    Enum.reduce(data, [], &add_level/2)
    |> Enum.group_by(&(&1["equipo"]))
    |> Map.values
    |> Enum.reduce([], fn data, acc ->
      data = add_team_average(data)
      |> Enum.reduce([], &add_salary/2)

      acc ++ data
    end)
  end

end
