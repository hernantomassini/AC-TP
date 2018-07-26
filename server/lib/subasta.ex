defmodule Subasta do
    @derive [Poison.Encoder]
    defstruct [:id, :idUsuario, :tags, :precioBase, :tiempoFinalizacion, :articulo]

    def new(idUsuario,mensaje) do
      instance=%Subasta{id: UUID.uuid1(), idUsuario: idUsuario}
      IO.inspect(instance)
      instance
    end

end

defmodule SubastaById do
    @derive [Poison.Encoder]
    defstruct [:id, :precioOfertado]
end