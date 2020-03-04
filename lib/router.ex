defmodule Enconta.Router do
  use Enconta, :router

  @doc """
  Este modulo es para declarar endpoints, la declaracion es muy simple y similar a Phoenix Framework
  Metodos aceptados: get, post, put, patch, delete

  Examples:

  get "/example/:id", Module.AnythingController, :show
  post "/example", Module.AnythingController, :create
  put "/example/:id", Module.AnythingController, :update
  patch "/example/:id", Module.AnythingController, :update
  delete "/example/:id", Module.AnythingController, :erase
  """

  post "/calculate_players_payment", Enconta.TeamController, :calculate_players_payment

end
