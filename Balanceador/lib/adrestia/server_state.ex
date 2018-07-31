defmodule Server.State do
  @derive [Poison.Encoder]
  defstruct [:subastas, :usuarios, :active]
end
