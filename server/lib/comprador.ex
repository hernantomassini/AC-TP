defmodule Comprador do
  @derive [Poison.Encoder]
  defstruct [:idComprador, :ip, :puerto, :tags]
end
