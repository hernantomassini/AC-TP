defmodule Modelo.Oferta do
  @derive [Poison.Encoder]
  defstruct [:id_subasta, :id_usuario, :valor_ofertado]
end
