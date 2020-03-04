defmodule Enconta do

  def controller do
    quote do
      import Plug.Conn
      import Enconta.Controller
    end
  end

  def router do
    quote do
      use Enconta.RouterBase
      import Enconta.RouterBase

      def init(opts), do: opts
      def call(conn, opts), do: request(conn, opts)
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

end
