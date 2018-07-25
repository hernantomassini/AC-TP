defmodule Subasta do
    @derive [Poison.Encoder]
    defstruct [:idVendedor, :tags, :precioBase, :tiempoFinalizacion, :articulo]
end
