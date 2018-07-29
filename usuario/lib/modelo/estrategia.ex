defmodule Modelo.Estrategia do
  @derive [Poison.Encoder]
  defstruct [:cant_reintentos,:sumar_al_precio,:no_mayor_a,:soy_reintentos,:soy_ofertar_hasta]

  @doc """
    cant_reintentos: Ofertara a cualquier oferta por "n" cantidad de veces superada esta cantidad dejara de ofertar
    sumar_al_precio:  Cuanto dinero extra aplicara para realizar la oferta
  """
  def reintentos(cant_reintentos, sumar_al_precio) do
    %Modelo.Estrategia{cant_reintentos: cant_reintentos, sumar_al_precio: sumar_al_precio, soy_reintentos: true, soy_ofertar_hasta: false}
  end

  @doc """
    no_mayor_a: Se ofertara siempre y cuando la oferta no sea mayro a este valor
    sumar_al_precio: Cuanto dinero extra aplicara para realizar la oferta
  """
  def oferta_hasta(no_mayor_a, sumar_al_precio) do
    %Modelo.Estrategia{no_mayor_a: no_mayor_a, sumar_al_precio: sumar_al_precio, soy_reintentos: false, soy_ofertar_hasta: true}
  end
end
