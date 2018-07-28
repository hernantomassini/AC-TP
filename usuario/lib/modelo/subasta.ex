defmodule Modelo.Subasta do
  @derive [Poison.Encoder]
  defstruct [:id, :idUsuario, :tags, :precioBase, :tiempoFinalizacion, :precioActual, :idGanador, :articuloNombre, :articuloDescripcion]

  def new(idUsuario, tags, precioBase, tiempoFinalizacion, articuloNombre, articuloDescripcion) do
    instance = %Modelo.Subasta{idUsuario: idUsuario, tags: tags, precioBase: precioBase, tiempoFinalizacion: tiempoFinalizacion, articuloNombre: articuloNombre, articuloDescripcion: articuloDescripcion}
    instance
  end
end

defmodule Modelo.OfertarSubasta do
  @derive [Poison.Encoder]
  defstruct [:idSubasta, :idUsuario, :precioOfertado]

  def new(idSubasta, idUsuario, precioOfertado) do
    instance = %Modelo.OfertarSubasta{idSubasta: idSubasta, idUsuario: idUsuario, precioOfertado: precioOfertado}
    instance
  end
end
