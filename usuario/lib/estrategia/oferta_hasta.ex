defmodule Estrategia.Ofertar_hasta do
    @moduledoc false
    use GenServer

    def init(:ok) do
      {:ok, %{}}
    end

    #defstruct [:cant_reintentos,:sumar_al_precio,:no_mayor_a,:soy_reintentos,:soy_ofertar_hasta]

    ## Client API
    def start_link(opts) do
      GenServer.start_link(__MODULE__, :ok, opts)
    end

    #  def ejecutar(pid_estrategia,id_usuario,subasta) do
    #    GenServer.cast(pid_estrategia, {:ejecutar_estrategia_ganar, id_usuario,subasta})
    #  end

    def handle_cast({:ejecutar, id_usuario,subasta}, estado_actual) do
      IO.puts("Ejecutando estrategia de ofertar hasta, usuario: #{id_usuario}")
      datos=estado_actual.datos
      #  defstruct [:cant_reintentos,:sumar_al_precio,:no_mayor_a,:soy_reintentos,:soy_ofertar_hasta]
      if(subasta.precio < datos.no_mayor_a) do
        valor_ofertado=obtener_precio_a_ofertar(subasta, datos.sumar_al_precio)
        IO.puts("USUAROI: #{id_usuario} Estrategia_Oferta_Hasta: #{datos.no_mayor_a} Precio Ofertado: #{valor_ofertado} para subasta: #{subasta.id}")
        Usuario.ofertar_subasta(id_usuario, subasta.id, valor_ofertado)
        else
          IO.puts("Usuario: #{id_usuario}. No tiene interes en subastas de precio mayor a #{datos.no_mayor_a} se rechaza subatas.id= #{subasta.id}. Producto: #{subasta.articulo_nombre}}")
        end
      {:noreply, estado_actual}
    end

    def obtener_precio_a_ofertar(subasta, aumentar_precio) do
      IO.inspect(subasta.precio, label: "subasta.precio")
      IO.inspect(aumentar_precio,label: "aumentar_precio")

      subasta.precio + aumentar_precio
    end

    def set_datos_estrategia(pid_estrategia, datos) do
      set_estado(pid_estrategia,%{datos: datos, ofertasRealizadas: MapSet.new()})
    end

    def set_estado(pid_estrategia, estado) do
      #    IO.inspect(estado, label: "Modelo.Reintentos.set_estado")
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
