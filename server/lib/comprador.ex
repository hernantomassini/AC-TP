defmodule Comprador do
  @derive [Poison.Encoder]
  defstruct [:id, :ip, :puerto, :tags]
end
