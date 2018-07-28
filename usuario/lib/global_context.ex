defmodule GlobalContext do
  @moduledoc false
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
    Guarda un elemnto clave valro en el contexto
  """
  def put(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))
  end

  @doc """
    Recupera un elemento en base a una key
  """
  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end

  def set_ip(ip) do
    GlobalContext.put("ip",ip)
  end

  def set_port(port) do
    GlobalContext.put("port", port)
  end

  def get_ip() do
    GlobalContext.get("ip")
  end

  def get_port() do
    GlobalContext.get("port")
  end

  def set_server_endpoint(server_endpoint) do
    GlobalContext.put("server_endpoint", server_endpoint)
  end

  def get_server_endpoint() do
    GlobalContext.get("server_endpoint")
  end


end
