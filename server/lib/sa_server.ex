defmodule SaServer do
  @moduledoc false

  def crear_subasta(x = %Subasta{}) do
    IO.inspect(x, label: "Success!")
    "Se a creado una subasta correctamente."
  end

   def postSubastaBy(id, x = %SubastaById{}) do
    IO.puts(id)
    IO.inspect(x, label: "Success!")
    "Oferta aplicada."
  end

  def deteleSubasta (id) do
    IO.puts(id)
    Response.new(id,"Se elimina una subasta")

  end

  def getByBuyer(id) do
    IO.puts(id)
    Response.new(id, "El comprador es #{id}")
#    "El comprador es #{id}"
  end

  # def agregar_comprador(x = %Comprador{id: id, ip: ip, puerto: puerto, tags: tags}) do
  def agregar_comprador(x = %Comprador{}) do
    IO.inspect(x, label: "Success!")
    Response.new(x, "El comprador fue agregado con exito.")
    # TODO: Guardar al comprador cuando haya un mecanismo para guardar el estado. Véase ETS - GenServer - Agent.
  end

end
