defmodule Modelo.Subasta do
  @derive [Poison.Encoder]
  defstruct [:id, :id_usuario, :tags, :precio, :tiempo_finalizacion, :id_ganador, :articulo_nombre, :articulo_descripcion]

  def new(id_usuario, tags, precio, tiempo_finalizacion, articulo_nombre, articulo_descripcion) do
    %Modelo.Subasta{id_usuario: id_usuario, tags: tags, precio: precio, tiempo_finalizacion: tiempo_finalizacion, articulo_nombre: articulo_nombre, articulo_descripcion: articulo_descripcion}
  end

  def equals(s1, s2) do
    s1.id == s2.id && s1.articulo_nombre == s2.articulo_nombre && s1.articulo_descripcion == s2.articulo_descripcion
    && s1.tags == s2.tags
  end
end

defmodule Modelo.OfertarSubasta do
  @derive [Poison.Encoder]
  defstruct [:id_subasta, :id_usuario, :valor_ofertado]

  def new(id_subasta, id_usuario, valor_ofertado) do
    %Modelo.OfertarSubasta{id_subasta: id_subasta, id_usuario: id_usuario, valor_ofertado: valor_ofertado}
  end
end


