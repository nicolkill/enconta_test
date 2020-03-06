defmodule EncontaTest do
  use ExUnit.Case

  alias Enconta.FootballTeam
  alias Enconta.Model.Player

  @test_data [
    %{
      "nombre" => "Juan Perez",
      "nivel" => "C",
      "goles" => 10,
      "sueldo" => 50000,
      "bono" => 25000,
      "sueldo_completo" => nil,
      "equipo" => "rojo"
    },
    %{
      "nombre" => "EL Cuauh",
      "nivel" => "Cuauh",
      "goles" => 30,
      "sueldo" => 100000,
      "bono" => 30000,
      "sueldo_completo" => nil,
      "equipo" => "azul"
    },
    %{
      "nombre" => "Cosme Fulanito",
      "nivel" => "A",
      "goles" => 7,
      "sueldo" => 20000,
      "bono" => 10000,
      "sueldo_completo" => nil,
      "equipo" => "azul"
    },
    %{
      "nombre" => "El Rulo",
      "nivel" => "B",
      "goles" => 9,
      "sueldo" => 30000,
      "bono" => 15000,
      "sueldo_completo" => nil,
      "equipo" => "rojo"
    }
  ]

  @test_players [
    %Player{
      nombre: "Juan Perez",
      goles_minimos: 15,
      goles: 10,
      sueldo: 50000,
      bono: 25000,
      sueldo_completo: nil,
      equipo: "rojo"
    },
    %Player{
      nombre: "EL Cuauh",
      goles_minimos: 20,
      goles: 30,
      sueldo: 100000,
      bono: 30000,
      sueldo_completo: nil,
      equipo: "azul"
    },
    %Player{
      nombre: "Cosme Fulanito",
      goles_minimos: 5,
      goles: 7,
      sueldo: 20000,
      bono: 10000,
      sueldo_completo: nil,
      equipo: "azul"
    },
    %Player{
      nombre: "El Rulo",
      goles_minimos: 10,
      goles: 9,
      sueldo: 30000,
      bono: 15000,
      sueldo_completo: nil,
      equipo: "rojo"
    }
  ]

  @test_players_team_averate [
    %Enconta.Model.Player{
      bono: 30000,
      equipo: "azul",
      goles: 30,
      goles_minimos: 20,
      nombre: "EL Cuauh",
      promedio_equipo: 1.45,
      sueldo: 100000,
      sueldo_completo: nil
    },
    %Enconta.Model.Player{
      bono: 10000,
      equipo: "azul",
      goles: 7,
      goles_minimos: 5,
      nombre: "Cosme Fulanito",
      promedio_equipo: 1.45,
      sueldo: 20000,
      sueldo_completo: nil
    },
    %Enconta.Model.Player{
      bono: 25000,
      equipo: "rojo",
      goles: 10,
      goles_minimos: 15,
      nombre: "Juan Perez",
      promedio_equipo: 0.7833333333333333,
      sueldo: 50000,
      sueldo_completo: nil
    },
    %Enconta.Model.Player{
      bono: 15000,
      equipo: "rojo",
      goles: 9,
      goles_minimos: 10,
      nombre: "El Rulo",
      promedio_equipo: 0.7833333333333333,
      sueldo: 30000,
      sueldo_completo: nil
    }
  ]

  @test_resp [
    %{
      nombre: "EL Cuauh",
      goles_minimos: 20,
      goles: 30,
      sueldo: 100000,
      bono: 30000,
      sueldo_completo: 144250.0,
      equipo: "azul"
    },
    %{
      nombre: "Cosme Fulanito",
      goles_minimos: 5,
      goles: 7,
      sueldo: 20000,
      bono: 10000,
      sueldo_completo: 34250.0,
      equipo: "azul"
    },
    %{
      nombre: "Juan Perez",
      goles_minimos: 15,
      goles: 10,
      sueldo: 50000,
      bono: 25000,
      sueldo_completo: 68125.0,
      equipo: "rojo"
    },
    %{
      nombre: "El Rulo",
      goles_minimos: 10,
      goles: 9,
      sueldo: 30000,
      bono: 15000,
      sueldo_completo: 42625.0,
      equipo: "rojo"
    }
  ]

  test "transform data to players" do
    assert {:ok, data} = FootballTeam.data_to_players(@test_data)

    assert data == @test_players
  end

  test "add team average goals to players" do
    assert {:ok, data} = FootballTeam.add_team_average(@test_players)

    assert data == @test_players_team_averate
  end

  test "transforms players to row data" do
    assert {:ok, data} = FootballTeam.transform_to_row_data(@test_players_team_averate)

    assert data == @test_resp
  end

  test "calculates player salary" do
    assert {:ok, data} = FootballTeam.calculate_players_payment(@test_data)

    assert data == @test_resp
  end
end
