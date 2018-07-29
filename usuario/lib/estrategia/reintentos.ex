
defmodule Estrategia.Reintentos do
  @moduledoc false
  use GenServer

  def init(:ok) do
    {:ok, %{}}
  end

  #--------------
  # Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

#  def ejecutar(pid_estrategia,id_usuario,subasta) do
#    GenServer.cast(pid_estrategia, {:ejecutar_estrategia_ganar, id_usuario,subasta})
#  end

  def handle_cast({:ejecutar, id_usuario,subasta}, estado_actual) do
    datos=estado_actual.datos
    mapa_ofertados=estado_actual.ofertasRealizadas
    cant_reinttos_realizados_subasta=Estrategia.Reintentos.obtener_cantidad_reintentos_subasta(mapa_ofertados,subasta.id)
    if(cant_reinttos_realizados_subasta < datos.cant_reintentos) do
      IO.puts("USUAROI: #{id_usuario} Estrategia_Reintentos_num: #{cant_reinttos_realizados_subasta} para subasta: #{subasta.id}")
      valor_ofertado=obtener_precio_a_ofertar(subasta, datos.sumar_al_precio)
      IO.inspect(valor_ofertado,label: "valor_ofertado")
      response=Usuario.ofertar_subasta(id_usuario, subasta.id, valor_ofertado)
      if(!response.error) do
        #aumentar cantida de reintentos de la subaasta
        estado_actual=%{estado_actual | ofertasRealizadas: Map.put(mapa_ofertados, subasta.id, cant_reinttos_realizados_subasta+1)}
        estado_actual.ofertasRealizadas
        {:noreply, estado_actual}
      end
      else
        IO.puts("Usuario: #{id_usuario}. Realizo maximo de reintentos para subatas.id= #{subasta.id}. Producto: #{subasta.articulo_nombre}}")
        {:noreply, estado_actual}
      end
  end

  def obtener_cantidad_reintentos_subasta(mapa, id_subasta) do
    if Map.has_key?(mapa, id_subasta) do
      {:ok,cant_reintentos_realizados}= Map.fetch(mapa, id_subasta)
      cant_reintentos_realizados
    else
      0
    end
  end

  def obtener_precio_a_ofertar(subasta, aumentar_precio) do
    IO.inspect(subasta.precio,label: "subasta.precio")
    IO.inspect(aumentar_precio,label: "aumentar_precio")

    subasta.precio + aumentar_precio
  end


  def set_datos_estrategia(pid_estrategia, datos) do
    set_estado(pid_estrategia,%{datos: datos, ofertasRealizadas: MapSet.new()})
  end

  def set_estado(pid_estrategia, estado) do
    GenServer.call(pid_estrategia, {:set_estado, estado})
  end

  def get_estado(pid_estrategia) do
    GenServer.call(pid_estrategia, {:get_estado})
  end

  def handle_call({:set_estado, estado}, _from, _) do
    {:reply,estado, estado}
  end

  def handle_call({:get_estado}, _from, estado_actual) do
    {:reply,estado_actual, estado_actual}
  end

end
