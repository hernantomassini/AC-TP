
defmodule Estrategia.Reintentos do
  @moduledoc false
  use GenServer


  def init(:ok) do
    {:ok, %{}}
  end


  ## Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end


#  def ejecutar(pidStrategia,idUsuario,subasta) do
#    GenServer.cast(pidStrategia, {:ejecutar_estrategia_ganar, idUsuario,subasta})
#  end

  def handle_cast({:ejecutar, idUsuario,subasta}, estado_actual) do
    datos=estado_actual.datos
    cant_reinttos_realizados_subasta=3
    if(cant_reinttos_realizados_subasta <= datos.cant_reintentos) do
      IO.puts("USUAROI: #{idUsuario} Estrategia_Reintentos_num: #{cant_reinttos_realizados_subasta} para subasta: #{subasta.id}")
      precio_ofertado=obtener_precio_a_ofertar(subasta, datos.sumar_al_precio)
      IO.inspect(precio_ofertado,label: "precio_ofertado")
      response=Usuario.ofertar_subasta(idUsuario, subasta.id, precio_ofertado)
      if(!response.error) do
        #aumentar cantida de reintentos de la subaasta
        {:noreply, estado_actual}
      end
    end
  end

  def obtener_precio_a_ofertar(subasta, aumentar_precio) do
    IO.inspect(subasta.precioActual,label: "precio_aqctual")
    IO.inspect(subasta.precioBase,label: "subasta.precio_base")
    IO.inspect(aumentar_precio,label: "aumentar_precio")
    if(subasta.precioActual !=nil) do
      subasta.precioActual+aumentar_precio
    else
      subasta.precioBase+aumentar_precio
    end

  end


  def set_datos_estrategia(pidStrategia, datos) do
    set_estado(pidStrategia,%{datos: datos, ofertasRealizadas: []})
  end

  def set_estado(pidStrategia, estado) do
#    IO.inspect(estado, label: "Modelo.Reintentos.set_estado")
    GenServer.call(pidStrategia, {:set_estado, estado})
    end

  def get_estado(pidStrategia) do
      GenServer.call(pidStrategia, {:get_estado})
    end

  def handle_call({:set_estado, estado}, _from, _) do
    {:reply,estado, estado}
  end

    def handle_call({:get_estado}, _from, estado_actual) do
      {:reply,estado_actual, estado_actual}
    end

end
