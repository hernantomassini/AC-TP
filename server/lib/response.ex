defmodule Response do
  @moduledoc false

  defstruct [:data,:error,:mensaje]

  def new(data,mensaje) do
    instance = %Response{data: data, mensaje: mensaje}
    IO.inspect(instance)
    Poison.encode!(instance)
  end

  def error(error, mensaje) do
    instance = %Response{error: error, mensaje: mensaje}
    IO.inspect(instance)
    Poison.encode!(instance)
  end
end
