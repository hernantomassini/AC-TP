defmodule Estrategia.Ofertar_hasta do
    @moduledoc false
    use GenServer


    def init(:ok) do
      {:ok, %{}}
    end

#    defstruct [:cant_reintentos,:sumar_al_precio,:no_mayor_a,:soy_reintentos,:soy_ofertar_hasta]

    ## Client API
    def start_link(opts) do
      GenServer.start_link(__MODULE__, :ok, opts)
    end


    #  def ejecutar(pidStrategia,idUsuario,subasta) do
    #    GenServer.cast(pidStrategia, {:ejecutar_estrategia_ganar, idUsuario,subasta})
    #  end

    def handle_cast({:ejecutar, id_usuario,subasta}, estado_actual) do
      datos=estado_actual.datos
      mapa_ofertados=estado_actual.ofertasRealizadas
      cant_reinttos_realizados_subasta=Estrategia.Reintentos.obtener_cantidad_reintentos_subasta(mapa_ofertados,subasta.id)
      if(cant_reinttos_realizados_subasta < datos.cant_reintentos) do
        IO.puts("USUAROI: #{id_usuario} Estrategia_Reintentos_num: #{cant_reinttos_realizados_subasta} para subasta: #{subasta.id}")
        precio_ofertado=obtener_precio_a_ofertar(subasta, datos.sumar_al_precio)
        IO.inspect(precio_ofertado,label: "precio_ofertado")
        response=Usuario.ofertar_subasta(id_usuario, subasta.id, precio_ofertado)
        if(!response.error) do
          #aumentar cantida de reintentos de la subaasta
          estado_actual=%{estado_actual | ofertasRealizadas: Map.put(mapa_ofertados, subasta.id, cant_reinttos_realizados_subasta+1)}
          estado_actual.ofertasRealizadas
          {:noreply, estado_actual}
        end
      else
        IO.puts("Usuario: #{id_usuario}. Realizo maximo de reintentos para subatas.id= #{subasta.id}. Producto: #{subasta.articuloNombre}}")
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
      set_estado(pidStrategia,%{datos: datos, ofertasRealizadas: MapSet.new()})
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
