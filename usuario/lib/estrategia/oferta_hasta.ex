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
      #  defstruct [:cant_reintentos,:sumar_al_precio,:no_mayor_a,:soy_reintentos,:soy_ofertar_hasta]
      if((subasta.precioBase <datos.no_mayor_a && subasta.precioActual ==nil) || (subasta.precioActual !=nil && subasta.precioActual< datos.no_mayor_a)) do
        precio_ofertado=obtener_precio_a_ofertar(subasta, datos.sumar_al_precio)
        IO.puts("USUAROI: #{id_usuario} Estrategia_Oferta_Hasta: #{datos.no_mayor_a} Precio Ofertado: #{precio_ofertado} para subasta: #{subasta.id}")
        response=Usuario.ofertar_subasta(id_usuario, subasta.id, precio_ofertado)
        else
          IO.puts("Usuario: #{id_usuario}. No tiene interes en subastas de precio mayor a #{datos.no_mayor_a} se rechaza subatas.id= #{subasta.id}. Producto: #{subasta.articuloNombre}}")
        end
      {:noreply, estado_actual}
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
