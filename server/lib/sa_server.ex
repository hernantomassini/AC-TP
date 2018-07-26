defmodule SaServer do
  @moduledoc false
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  defp get() do
    Agent.get(__MODULE__, fn list -> list end)
  end

  defp put(value) do
    Agent.update(__MODULE__, fn list -> [ value | list ] end)
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
  def agregar_comprador(usuario) do
    put(usuario)
    IO.inspect(get(), label: "Lista de usuarios")
    Response.new(usuario, "El usuario fue agregado con exito.")
  end
end
