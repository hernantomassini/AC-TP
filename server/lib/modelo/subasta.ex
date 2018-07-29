defmodule Modelo.Subasta do
  @derive [Poison.Encoder]
  defstruct [:id, :idUsuario, :tags, :precio, :tiempoFinalizacion, :idGanador, :articuloNombre, :articuloDescripcion, :estado]

  @doc """
    Estados de una subasta: :activo - :cancelada - :terminada
  """
  def new(%Modelo.Subasta{idUsuario: idUsuario, tags: tags, precio: precio, tiempoFinalizacion: tiempoFinalizacion, articuloNombre: articuloNombre, articuloDescripcion: articuloDescripcion}) do
    %Modelo.Subasta{id: UUID.uuid1(), idUsuario: idUsuario, tags: tags, precio: precio, tiempoFinalizacion: tiempoFinalizacion, articuloNombre: articuloNombre, articuloDescripcion: articuloDescripcion, estado: :activo}
  end

  def new(idUsuario, tags, precio, tiempoFinalizacion, articuloNombre, articuloDescripcion) do
    %Modelo.Subasta{id: UUID.uuid1(), idUsuario: idUsuario, tags: tags, precio: precio, tiempoFinalizacion: tiempoFinalizacion, articuloNombre: articuloNombre, articuloDescripcion: articuloDescripcion, estado: :activo}
  end
end

defmodule SubastaById do
  @derive [Poison.Encoder]
  defstruct [:id, :precioOfertado]
end
