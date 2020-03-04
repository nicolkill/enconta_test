defmodule Enconta.RouterBase do
  use Plug.Builder

  import Plug.Conn

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason
  plug Plug.MethodOverride
  plug Plug.Head
  plug :request

  @http_methods [:get, :post, :put, :patch, :delete]

  @doc """
  Este modulo configura el router y agrega funciones utiles para crear endpoints de forma rapida

  Los endpoints se guardan en Erlang ETS con llaves en formato KEY-PATH
  """

  defmacro __using__(_), do: :ok

  @doc """
  Aqui llegan los request entrantes, verifica si hay un endpoint condigurado previamente lo llamara

  Si el endpoint no existe mandara un 404 por default
  Si sucede un error en la ejecucion del metodo externo este pasara la excepcion asi como va, habra falta configurar y
  crear un fallback_controller
  """
  def request(%{method: method, request_path: path, params: params} = conn, _) do
    key = to_key(method, path)
    {_, %{module: module, function: function}} = :ets.lookup(:routes, key) |> Enum.at(0)

    apply(module, function, [conn, params])
  rescue
    _ in MatchError -> send_resp(conn, 404, "not found")
  end

  defp to_key(method, path), do: "#{path}-#{method}" |> String.downcase
  defp array_to_module(arr) when is_list(arr), do: ["Elixir"] ++ arr |> Enum.join(".") |> String.to_existing_atom

  defmacro match(method, path, module, function), do: add_path(method, path, module, function)

  @doc """
  Agrega los metodos http en forma de macro que ayuda a configurar los endpoints de forma rapida
  """
  for verb <- @http_methods do
    defmacro unquote(verb)(path, module, function), do: add_path(unquote(verb), path, module, function)
  end

  @doc """
  Agrega al ETS el endpoint con su key formateado
  """
  defp add_path(method, path, {_, _, module}, function) do
    key = to_key(method, path)
    module = array_to_module(module)

    :ets.insert(:routes, {key, %{module: module, function: function}})
  end

end