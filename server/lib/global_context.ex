defmodule GlobalContext do
  @moduledoc false
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [subastas: MapSet.new(), usuarios: MapSet.new()] end, name: __MODULE__)
  end

  # type es un átomo :subastas o :usuarios
  defp get(type) when is_atom(type) do
    Agent.get(__MODULE__, fn list -> Keyword.get(list, type) end)
  end

  defp put(type, value) when is_atom(type) do
    Agent.update(__MODULE__, fn list -> put_in(list[type], MapSet.put(list[type], value)) end)
  end

  #---------------------------------------

  def get_usuarios() do
    get(:usuarios)
  end

  def get_subastas() do
    get(:subastas)
  end

  def registrar_usuario(usuario) do
    put(:usuarios, usuario)
  end

  def crear_subasta(subasta) do
    put(:subastas, subasta)
  end

end
