defmodule SaServer do
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
    Agent.update(__MODULE__, fn listMapSet -> put_in(listMapSet[type], MapSet.put(listMapSet[type], value)) end)
  end

  #-------------------------

  def crear_subasta(x = %Subasta{}) do
    IO.inspect(x, label: "Success!")
    "Se a creado una subasta correctamente."
  end

  def post_subasta_by(id, x = %SubastaById{}) do
    IO.puts(id)
    IO.inspect(x, label: "Success!")
    "Oferta aplicada."
  end

  def delete_subasta(id) do
    IO.puts(id)
    Response.new(id,"Se elimina una subasta")
  end

  def get_by_buyer(id) do
    IO.puts(id)
    Response.new(id, "El comprador es #{id}")
    # "El comprador es #{id}"
  end

  # usario es %Usuario
  def agregar_usuario(usuario) do
    put(:usuarios, usuario)
    IO.inspect(get(:usuarios), label: "Lista de usuarios")

    # subastas_de_interes = Usuario.subastas_de_interes(usuario.tags, subastas)

    Response.new(usuario, "El usuario fue agregado con exito.")
  end
end
