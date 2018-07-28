
defmodule Estrategia.Reintentos do
  @moduledoc false
  use GenServer

  @derive [Poison.Encoder]



  def init(:ok) do
    {:ok, %{}}
  end


  ## Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end


  def ejecutar(pidStrategia,idUsuario,subasta = %Modelo.Subasta{}) do
    GenServer.cast(pidStrategia, {:ejecutar_estrategia_ganar, idUsuario,subasta})
  end

  def handle_cast({:ejecutar_estrategia_ganar, idUsuario,subasta}, estado) do
    precioOfertado=subasta.precioBase
    if(subasta.precioActual !=nil) do
      precioOfertado=subasta.precioActual
    end

    Usuario.ofertar_subasta(idUsuario, subasta.id, precioOfertado)

  end

    def set_estado(pidStrategia, estado = %Modelo.Estrategia{}) do
      GenServer.call(pidStrategia, {:set_estado, estado})
    end

    def get_estado(pidStrategia) do
      GenServer.call(pidStrategia, {:get_estado})
    end

  def handle_call({:set_estado, estado = %Modelo.Estrategia{}}, _from, usuarios) do
    {:reply,estado, estado}
  end

    def handle_call({:get_estado}, _from, estado) do
      {:reply,estado, estado}
    end

end
