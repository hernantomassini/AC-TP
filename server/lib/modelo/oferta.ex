defmodule Modelo.Oferta do
  @derive [Poison.Encoder]
  defstruct [:idSubasta, :idUsuario, :valorOfertado]
end
