defmodule Modelo.Subasta do
  @derive [Poison.Encoder]
  defstruct [:id, :idUsuario, :tags, :precioBase, :tiempoFinalizacion, :precioActual, :idGanador, :articuloNombre, :articuloDescripcion]

  def new(idUsuario, tags, precioBase, tiempoFinalizacion, articuloNombre, articuloDescripcion) do
    %Modelo.Subasta{id: UUID.uuid1(), idUsuario: idUsuario, tags: tags, precioBase: precioBase, tiempoFinalizacion: tiempoFinalizacion, articuloNombre: articuloNombre, articuloDescripcion: articuloDescripcion}
  end

  def initialize(subasta) do
    put_in(subasta.id, UUID.uuid1())
  end
end

defmodule SubastaById do
  @derive [Poison.Encoder]
  defstruct [:id, :precioOfertado]
end
