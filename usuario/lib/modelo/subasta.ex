defmodule Modelo.Subasta do
  @derive [Poison.Encoder]
  defstruct [:id, :idUsuario, :tags, :precio, :tiempoFinalizacion, :idGanador, :articuloNombre, :articuloDescripcion]

  def new(idUsuario, tags, precio, tiempoFinalizacion, articuloNombre, articuloDescripcion) do
    %Modelo.Subasta{idUsuario: idUsuario, tags: tags, precio: precio, tiempoFinalizacion: tiempoFinalizacion, articuloNombre: articuloNombre, articuloDescripcion: articuloDescripcion}
  end
end

defmodule Modelo.OfertarSubasta do
  @derive [Poison.Encoder]
  defstruct [:idSubasta, :idUsuario, :precioOfertado]

  def new(idSubasta, idUsuario, precioOfertado) do
    %Modelo.OfertarSubasta{idSubasta: idSubasta, idUsuario: idUsuario, precioOfertado: precioOfertado}
  end
end
