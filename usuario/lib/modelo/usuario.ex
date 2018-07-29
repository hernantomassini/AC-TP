defmodule Modelo.Usuario do
  @moduledoc false
  @derive [Poison.Encoder]
  defstruct [:id, :ip, :puerto, :tags,:pid_estrategia]

  def new(id, tags, estrategia_oferta) do
#    pid_estrategia=nil
#    if(estrategia_oferta.soy_reintentos) do
#      pid_estrategia= Estrategia.Reintentos.start_link([])
#      # def set_estado(pidStrategia, estado = %Modelo.Estrategia{}) do
#      Estrategia.Reintentos.set_estado(pid_estrategia, estrategia_oferta)
#    end

    %Modelo.Usuario{id: id, tags: tags, ip: GlobalContext.get_ip(), puerto: GlobalContext.get_port(), pid_estrategia: Modelo.Usuario.get_estrategia(estrategia_oferta)}
  end


  def get_estrategia(estrategia_oferta)do
    if(estrategia_oferta.soy_reintentos) do
      {:ok, pid_estrategia}= Estrategia.Reintentos.start_link([])
      # def set_estado(pidStrategia, estado = %Modelo.Estrategia{}) do
      Estrategia.Reintentos.set_datos_estrategia(pid_estrategia, estrategia_oferta)
      pid_estrategia
    else
      if(estrategia_oferta.soy_ofertar_hasta) do
        {:ok, pid_estrategia}= Estrategia.Ofertar_hasta.start_link([])
        # def set_estado(pidStrategia, estado = %Modelo.Estrategia{}) do
        Estrategia.Ofertar_hasta.set_datos_estrategia(pid_estrategia, estrategia_oferta)
        pid_estrategia
        end
    end
  end


end
