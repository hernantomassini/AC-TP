defmodule Response.Struct do
  @moduledoc false
  @derive [Poison.Encoder]
  defstruct [:data,:error,:mensaje]
end

defmodule Response do
  @moduledoc false

  def new(data,mensaje) do
    instance=%Response.Struct{data: data, mensaje: mensaje}
    IO.inspect(instance)
    Poison.encode!(instance)
  end

  def newError(error, mensaje) do
    instance=%Response.Struct{error: error, mensaje: mensaje}
    IO.inspect(instance)
   Poison.encode!(instance)
  end

end
