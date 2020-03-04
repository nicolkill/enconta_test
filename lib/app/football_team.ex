defmodule Enconta.FootballTeam do

  @levels %{
    "A" => 5,
    "B" => 10,
    "C" => 15,
    "Cuauh" => 20
  }

  @doc """
  Agrega el minimo de goles dependiendo el nivel del jugador y el promedio individual y elimina el campo nivel ya que
  no es necesario a partir de este punto
  """
  defp process_player(%{"nivel" => level, "goles" => goles} = player, data) do
    goles_minimos = Map.get(@levels, level)

    player = player
    |> Map.put("goles_minimos", goles_minimos)
    |> Map.put("promedio", goles / goles_minimos)
    |> Map.delete("nivel")

    data ++ [player]
  end

  @doc """
  Calcula el bono dinamico a partir de el promedio individual y el promedio de equipo
  """
  defp process_player(%{"bono" => bono, "promedio" => promedio, "promedio_equipo" => promedio_equipo} = player, data) do
    sueldo_completo = bono * ((promedio_equipo + promedio) / 2)
    |> Float.round(4)

    player = player
    |> Map.put("sueldo_completo", sueldo_completo)
    |> Map.delete("promedio")
    |> Map.delete("promedio_equipo")

    data ++ [player]
  end

  @doc """
  Hace la suma del sueldo a el bono
  """
  defp process_player(%{"sueldo_completo" => sueldo_completo, "sueldo" => sueldo} = player, data) do
    player = Map.put(player, "sueldo_completo", sueldo_completo + sueldo)

    data ++ [player]
  end

  @doc """
  Agrega el promedio de equipo a cada jugador del equipo
  """
  defp process_player(data) do
    sumatoria = Enum.reduce(data, 0, &(&1["promedio"] + &2))

    Enum.reduce(data, [], fn player, acc ->
      prom = sumatoria / length(data)
      player = Map.put(player, "promedio_equipo", prom)

      acc ++ [player]
    end)
  end

  @doc """
  Calcula los salarios de un arreglo de jugadores

  Estos se segmentan por el campo "equipo" y a partir de ahi se calculan los salarios
  """
  def calculate_players_payment(data) do
    data
    |> Enum.reduce([], &process_player/2)
    |> Enum.group_by(&(&1["equipo"]))
    |> Map.values
    |> Enum.reduce([], fn data, acc -> acc ++ process_player(data) end)
    |> Enum.reduce([], &process_player/2)
    |> Enum.reduce([], &process_player/2) # Comenta esta linea si no quieres que sume el salario estatico al bono
  end

end
