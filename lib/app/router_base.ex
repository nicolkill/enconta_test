defmodule Enconta.RouterBase do
  use Plug.Builder

  import Plug.Conn

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason
  plug Plug.MethodOverride
  plug Plug.Head

  alias Enconta.Route

  @http_methods [:get, :post, :put, :patch, :delete]

  @doc """
  Este modulo configura el router y agrega funciones utiles para crear endpoints de forma rapida

  Los endpoints se guardan en un module atribute al momento de compilar y se agregan en forma de funciones
  """

  defmacro __using__(_) do
    quote do
      unquote(setup())
    end
  end

  defp setup do
    quote do
      plug :request

      @doc """
      Aqui llegan los request entrantes, verifica si hay un endpoint condigurado previamente lo llamara

      Si el endpoint no existe mandara un 404 por default
      Si sucede un error en la ejecucion del metodo externo este pasara la excepcion asi como va, habra falta configurar y
      crear un fallback_controller
      """
      def request(%{method: method, request_path: path, body_params: %Plug.Conn.Unfetched{aspect: :body_params}} = conn, opts) do
        # por alguna razon recibe la data de postman un poco feo y hay que darle su propio formato
        {:ok, body, _} = read_body(conn)

        body = String.replace(body, "\n", "")
        |> String.replace("\\", "")
        |> Jason.decode!

        request(method, path, conn, body)
      end

      def request(%{method: method, request_path: path, body_params: body_params, params: params} = conn, _) do
        request(method, path, conn, Map.merge(body_params, params))
      end

      def request(method, path, conn, params) do
        method = method |> String.downcase |> String.to_atom
        apply(__MODULE__, :call, [conn, params, method, path])
      rescue
        e in FunctionClauseError-> send_resp(conn, 404, "not found")
      end

      Module.register_attribute(__MODULE__, :routes, accumulate: true)

      @before_compile Enconta.RouterBase
    end
  end

  defmacro __before_compile__(env) do
    routes = env.module |> Module.get_attribute(:routes) |> Enum.reverse

    for route <- routes do
      quote do
        def call(conn, params, unquote(route.method), unquote(route.path)) do
          apply(unquote(route.module), unquote(route.function), [conn, params])
        end
      end
    end
  end

  defp array_to_module(arr) when is_list(arr), do: ["Elixir"] ++ arr |> Enum.join(".") |> String.to_existing_atom

  defmacro match(method, path, module, function), do: add_path(method, path, module, function)

  @doc """
  Agrega los metodos http en forma de macro que ayuda a configurar los endpoints de forma rapida
  """
  for verb <- @http_methods do
    defmacro unquote(verb)(path, module, function), do: add_path(unquote(verb), path, module, function)
  end

  @doc """
  Agrega al atributo el endpoint como struct
  """
  defp add_path(method, path, {_, _, module}, function) do
    quote do
      @routes %Route{
        method: unquote(method),
        path: unquote(path),
        module: unquote(array_to_module(module)),
        function: unquote(function)
      }
    end
  end

end