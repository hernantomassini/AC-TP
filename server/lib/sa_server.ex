defmodule SaServer do
  @moduledoc false

  def crear_subasta(params) do
    IO.puts("Soy crear subasta, mucho gusto.")
    IO.inspect(params)
  end

  # def agregar_comprador(x = %Comprador{idComprador: id, ip: ip, puerto: puerto, tags: tags}) do
  def agregar_comprador(x = %Comprador{}) do
    IO.inspect(x, label: "Success!")

    # TODO: Guardar al comprador cuando haya un mecanismo para guardar el estado. Véase ETS - GenServer - Agent.

    "Retorno este gran string."
  end
end
