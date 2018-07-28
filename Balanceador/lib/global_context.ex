defmodule GlobalContext do
  @moduledoc false
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end,name: __MODULE__)
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

  def set_endpoints(endpoints) do
    GlobalContext.put("endpoints",endpoints)
  end

  def get_endpoints() do
    GlobalContext.get("endpoints")
  end

 end
