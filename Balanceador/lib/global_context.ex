defmodule GlobalContext do
  @moduledoc false
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end,name: __MODULE__)
  end

  @doc """
    Guarda un elemnto clave valro en el contexto
  """
  def put(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))
  end

  @doc """
    Recupera un elemento en base a una key
  """
  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end

  def set_endpoints(endpoints) do
    if endpoints == nil do
      GlobalContext.put("endpoints",[])
    end
    GlobalContext.put("endpoints",endpoints)
  end

  def get_endpoints() do
    GlobalContext.get("endpoints")
  end

  def get_endpoint_maestro() do
    GlobalContext.get("endpoint_maestro")
  end

  def set_endpoint_maestro(endpoint) do
    GlobalContext.put("endpoint_maestro",endpoint)
  end



  def get_endpoints_esclavos() do
    activos=GlobalContext.get_endpoints_activos()
    maestro=GlobalContext.get_endpoint_maestro()
    Enum.filter(activos, fn x -> x.host != maestro.host end)
  end

  def set_endpoints_esclavos(endpoints) do
    if endpoints == nil do
      GlobalContext.put("endpoints_esclavos",[])
    end
    GlobalContext.put("endpoints_esclavos",endpoints)
  end

  def get_endpoints_activos() do
    GlobalContext.get("endpoints_activos")
  end

  def set_endpoints_activos(endpoints) do
    if endpoints == nil do
      GlobalContext.put("endpoints_activos",[])
    end
    GlobalContext.put("endpoints_activos",endpoints)
  end


  def obtener_endpoint_maestro()do
    activos=GlobalContext.get_endpoints_activos()
    maestro=GlobalContext.get_endpoint_maestro()
    #SI el maestro no existe en la lista y la lista de activos no esta vacia
    if ( maestro == nil && !Enum.empty?(activos)) || (maestro !=nil && !Enum.any?(activos, fn x -> x.host == maestro.host end) && !Enum.empty?(activos))   do
            IO.puts("Se toma de #{inspect(activos)}")
            IO.puts("Se agrega #{inspect(Enum.at(activos,0))}")
      GlobalContext.set_endpoint_maestro(Enum.at(activos,0)) #Toma el priemro de los activos que no son EL xD

    end
    GlobalContext.get_endpoint_maestro()
  end



 end
