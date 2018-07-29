defmodule Response do
  @moduledoc false
  defstruct [:data,:error,:mensaje]

  def new(data,mensaje) do
    instance = %Response{data: data, mensaje: mensaje,error: false}
    IO.inspect(instance)
    Poison.encode!(instance)
  end

  def new(mensaje) do
      new(nil,mensaje)
  end


  def error(mensaje) do
    instance = %Response{error: true, mensaje: mensaje}
    IO.inspect(instance)
    Poison.encode!(instance)
  end

  def decode(input) do
    {:ok,httpPoinson}=input
    #    IO.inspect(httpPoinson.body, label: "sarasra")#
    Poison.decode!(httpPoinson.body, as: %Response{})
  end

end
