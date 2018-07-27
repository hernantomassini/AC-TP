defmodule Modelo.Subasta do


  @derive [Poison.Encoder]
  defstruct [:id, :idUsuario, :tags, :precioBase, :tiempoFinalizacion, :precioActual, :idGanador, :articuloNombre, :articuloDescripcion]

  def new(idUsuario,tags,precioBase,tiempoFinalizacion,articuloNombre,articuloDescripcion) do
    instance=%Modelo.Subasta{id: UUID.uuid1(), idUsuario: idUsuario, tags: tags, precioBase: precioBase, tiempoFinalizacion: tiempoFinalizacion, articuloNombre: articuloNombre, articuloDescripcion: articuloDescripcion }
#    //IO.inspect(instance)
    instance
  end
end

defmodule Modelo.OfertarSubasta do
  @derive [Poison.Encoder]
  defstruct [:idSubasta,:idUsuario, :precioOfertado]

  def new(idSubasta,idUsuario,precioOfertado) do
    instance=%Modelo.OfertarSubasta{idSubasta: idSubasta, idUsuario: idUsuario,  precioOfertado: precioOfertado}
    #    //IO.inspect(instance)
    instance
  end
end