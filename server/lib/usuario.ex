defmodule Usuario do
  @derive [Poison.Encoder]
  defstruct [:id, :ip, :puerto, :tags]

  def subastas_de_interes(tags, subastas) do

  end

end
