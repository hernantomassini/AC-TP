defmodule GlobalContext do
  @moduledoc false
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [subastas: MapSet.new(), usuarios: MapSet.new()] end, name: __MODULE__)
  end

  # type es un átomo :subastas o :usuarios
  defp get(type) when is_atom(type) do
    Agent.get(__MODULE__, fn data -> data[type] end)
  end

  defp get(type, id) when is_atom(type) do
    Agent.get(__MODULE__, fn data -> Enum.find(data[type], fn x -> x.id === id end) end)
  end

  defp put(type, value) when is_atom(type) do
    Agent.update(__MODULE__, fn data -> put_in(data[type], MapSet.put(data[type], value)) end)
  end

  defp update(type, value) when is_atom(type) do
    Agent.update(__MODULE__, fn data -> put_in(data[type], Enum.reject(data[type], fn x -> x.id === value.id end) |> MapSet.put(value)) end)
  end

  #---------------------------------------

  def get_usuarios() do
    get(:usuarios)
  end

  def get_subastas() do
    get(:subastas)
  end

  def get_subasta(id) do
    get(:subastas, id)
  end

  def registrar_usuario(usuario) do
    put(:usuarios, usuario)
  end

  def crear_subasta(subasta) do
    put(:subastas, subasta)
  end

  def modificar_subasta(subasta) do
    update(:subastas, subasta)
  end

end
