defmodule Response do
  @moduledoc false
  defstruct [:data,:error,:mensaje]

  def new(data,mensaje) do
    instance = %Response{data: data, mensaje: mensaje,error: false}
    Poison.encode!(instance)
  end

  def error(mensaje) do
    instance = %Response{error: true, mensaje: mensaje}
    Poison.encode!(instance)
  end

  def new(mensaje) do
    new(nil,mensaje)
  end

end
