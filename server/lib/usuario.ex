defmodule Usuario do
  @derive [Poison.Encoder]
  defstruct [:id, :ip, :puerto, :tags]
end
