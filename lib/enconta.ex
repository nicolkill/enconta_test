defmodule Enconta do

  @levels %{
    "A" => 5,
    "B" => 10,
    "C" => 15,
    "Cuauh" => 20
  }

  defp process_player(%{"nivel" => level, "goles" => goles} = player, data) do
    goles_minimos = Map.get(@levels, level)

    player = Map.put(player, "goles_minimos", goles_minimos)
    |> Map.put("promedio", goles / goles_minimos)
    |> Map.delete("nivel")

    data ++ [player]
  end

  defp process_player(data) do
    sumatoria = Enum.reduce(data, 0, &(&1["promedio"] + &2))

    Enum.reduce(data, [], fn player, acc ->
      prom = sumatoria / length(data)
      player = Map.put(player, "promedio_equipo", prom)

      acc ++ [player]
    end)
  end

  defp process_player(%{"bono" => bono, "promedio" => promedio, "promedio_equipo" => promedio_equipo, "sueldo" => sueldo} = player, data) do
    sueldo_completo = (bono * ((promedio_equipo + promedio) / 2)) + sueldo
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
    Enum.reduce(data, [], &process_player/2)
    |> Enum.group_by(&(&1["equipo"]))
    |> Map.values
    |> Enum.reduce([], fn data, acc ->
      data = process_player(data)
      |> Enum.reduce([], &process_player/2)

      acc ++ data
    end)
  end

end
