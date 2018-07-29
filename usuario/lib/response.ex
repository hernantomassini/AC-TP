defmodule Response do
  @moduledoc false
  defstruct [:data,:error,:mensaje]

  def new(data,mensaje) do
    instance = %Response{data: data, mensaje: mensaje,error: false}
    IO.inspect(instance)
    Poison.encode!(instance)
  end

  def error(mensaje) do
    instance = %Response{error: true, mensaje: mensaje}
    IO.inspect(instance)
    Poison.encode!(instance)
  end
end
