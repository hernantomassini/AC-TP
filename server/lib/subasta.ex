defmodule Subasta do
    @derive [Poison.Encoder]
    defstruct [:idVendedor, :tags, :precioBase, :tiempoFinalizacion, :articulo]
end

defmodule SubastaById do
    @derive [Poison.Encoder]
    defstruct [:id, :precioOfertado]
end