defmodule Modelo.Subasta do
  @derive [Poison.Encoder]
  defstruct [:id, :id_usuario, :tags, :precio, :tiempo_finalizacion, :id_ganador, :articulo_nombre, :articulo_descripcion, :estado, :participantes]

  @doc """
    Estados de una subasta: :activa - :cancelada - :terminada
  """
  def new(%Modelo.Subasta{id_usuario: id_usuario, tags: tags, precio: precio, tiempo_finalizacion: tiempo_finalizacion, articulo_nombre: articulo_nombre, articulo_descripcion: articulo_descripcion}) do
    %Modelo.Subasta{id: UUID.uuid1(), id_usuario: id_usuario, tags: tags, precio: precio, tiempo_finalizacion: tiempo_finalizacion, articulo_nombre: articulo_nombre, articulo_descripcion: articulo_descripcion, estado: :activa, participantes: []}
  end

  def new(id_usuario, tags, precio, tiempo_finalizacion, articulo_nombre, articulo_descripcion) do
    %Modelo.Subasta{id: UUID.uuid1(), id_usuario: id_usuario, tags: tags, precio: precio, tiempo_finalizacion: tiempo_finalizacion, articulo_nombre: articulo_nombre, articulo_descripcion: articulo_descripcion, estado: :activa, participantes: []}
  end

  def activa?(subasta) do
    subasta.estado == :activa
  end
end

defmodule SubastaById do
  @derive [Poison.Encoder]
  defstruct [:id, :valor_ofertado]
end
