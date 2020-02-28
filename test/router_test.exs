defmodule Enconta.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias Enconta.Router

  @test_data %{
    jugadores: [
      %{
        nombre:  "Juan Perez",
        nivel:  "C",
        goles:  10,
        sueldo:  50000,
        bono:  25000,
        sueldo_completo:  nil,
        equipo:  "rojo"
      },
      %{
        nombre: "EL Cuauh",
        nivel: "Cuauh",
        goles: 30,
        sueldo: 100000,
        bono: 30000,
        sueldo_completo: nil,
        equipo: "azul"
      },
      %{
        nombre: "Cosme Fulanito",
        nivel: "A",
        goles: 7,
        sueldo: 20000,
        bono: 10000,
        sueldo_completo: nil,
        equipo: "azul"
      },
      %{
        nombre: "El Rulo",
        nivel: "B",
        goles: 9,
        sueldo: 30000,
        bono: 15000,
        sueldo_completo: nil,
        equipo: "rojo"
      }
    ]
  }

  @test_resp [
    %{
      "nombre" => "EL Cuauh",
      "goles_minimos" =>  20,
      "goles" => 30,
      "sueldo" =>100000,
      "bono" => 30000,
      "sueldo_completo" => 44250.0,
      "equipo" => "azul"
    },
    %{
      "nombre" => "Cosme Fulanito",
      "goles_minimos" =>  5,
      "goles" => 7,
      "sueldo" => 20000,
      "bono" => 10000,
      "sueldo_completo" => 14250.0,
      "equipo" => "azul"
    },
    %{
      "nombre" =>  "Juan Perez",
      "goles_minimos" =>  15,
      "goles" =>  10,
      "sueldo" =>  50000,
      "bono" =>  25000,
      "sueldo_completo" =>  18125.0,
      "equipo" =>  "rojo"
    },
    %{
      "nombre" =>  "El Rulo",
      "goles_minimos" =>  10,
      "goles" =>  9,
      "sueldo" =>  30000,
      "bono" =>  15000,
      "sueldo_completo" =>  12625.0,
      "equipo" =>  "rojo"
    }
  ]

  @opts Router.init([])

  test "returns test data" do
    conn =
      :post
      |> conn("/calculate_players_payment", @test_data)
      |> Router.call(@opts)

    resp_body = Jason.decode!(conn.resp_body)

    assert conn.status == 200
    assert resp_body["data"] == @test_resp
  end

end