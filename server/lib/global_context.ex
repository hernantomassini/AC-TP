defmodule GlobalContext do
  @moduledoc false
  use Agent

  @derive [Poison.Encoder]
  defstruct [:subastas, :usuarios, :active]

  def start_link(_opts) do
    Agent.start_link(fn -> [subastas: [], usuarios: [], active: false] end, name: __MODULE__)
  end

  defp get() do
    Agent.get(__MODULE__, fn data -> data end)
  end

  # type es un átomo :subastas o :usuarios
  defp get(type) when is_atom(type) do
    Agent.get(__MODULE__, fn data -> data[type] end)
  end

  defp get(type, id) when is_atom(type) do
    Agent.get(__MODULE__, fn data -> Enum.find(data[type], fn x -> String.downcase(x.id) === String.downcase(id) end) end)
  end

  defp put(state) do
    Agent.update(__MODULE__, fn _ -> state end)
  end

  defp put(type, value) when is_atom(type) do
    Agent.update(__MODULE__, fn data -> put_in(data[type], [ value | data[type] ]) end)
  end

  defp update(type, value) when is_atom(type) do
    Agent.update(__MODULE__, fn data -> put_in(data[type], [ value | Enum.reject(data[type], fn x -> x.id === value.id end) ]) end)
  end

  #---------------------------------------

  def get_estado() do
    get()
  end

  def export_estado() do
    estado = get_estado()
    %GlobalContext{subastas: estado[:subastas], usuarios: estado[:usuarios], active: estado[:active]}
  end

  def import_estado(%GlobalContext{subastas: subastas, usuarios: usuarios, active: active}) do
    estado = [subastas: subastas, usuarios: usuarios, active: active]
    set_estado(estado)
  end

  def set_estado(estado) do
    put(put_in(estado[:active], true))
  end

  def get_usuarios() do
    get(:usuarios)
  end

  def get_subastas() do
    get(:subastas)
  end

  def get_usuario(id) do
    get(:usuarios, id)
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

  def is_active() do
    get(:active)
  end

end
