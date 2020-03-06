defmodule Enconta.Base.Controller do
  import Plug.Conn

  @moduledoc """
  Este modulo tiene helpers para los controladores
  """

  @doc """
  Finaliza la coneccion enviando un json como respuesta y un codigo 200
  """
  def send_json(conn, response) do
    response = Jason.encode!(response)

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, response)
  end

end
