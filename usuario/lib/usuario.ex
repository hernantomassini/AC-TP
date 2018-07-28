

defmodule Usuario do
  @moduledoc false
  use HTTPoison.Base
  import Usuario.Registry, only: [get_pid_usuario: 1]

  def process_url(url) do
    GlobalContext.get_server_endpoint() <> url
  end

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Gets a value from the `instance` by `key`.
  """
  def state(instance) do
    Agent.get(instance, &Map.get(&1, "state"))
  end

  @doc """
  Puts the `value` for the given `key` in the `instance`.
  """
  def save(instance, value) do
    Agent.update(instance, &Map.put(&1, "state", value))
  end


  @doc """
    COMPORTAMIEOT  DE ITERACCION CON SERVIDOR
  """

  def registrar_usuario(usuario) when is_pid(usuario) do
    body=Poison.encode!(Usuario.state(usuario))
    response=Usuario.post("/buyers",body)
    IO.inspect(response.body,label: "registrar_usuario")
  end

  def registrar_usuario(usuario) when is_bitstring(usuario) do
    pid = get_pid_usuario(usuario)
    registrar_usuario(pid)
  end


  def consultar_usuario(instance) do
    usuario=Usuario.state(instance)
    response=Usuario.get("/buyers/#{usuario.id}"  )
    IO.inspect(response,label: "consultar_usuario")
  end

  def crear_usuario(usuario) when is_bitstring(usuario) do
    pid = get_pid_usuario(usuario)
    crear_usuario(pid)
  end

  def crear_usuario(usuario) when is_pid(usuario) do
    body=Poison.encode!(Usuario.get(usuario))
    response=Usuario.post("/bids",body)
    IO.inspect(response, label: "crear_usuario")
  end


  def obtener_subasta(usuario) when is_pid(usuario) do
    body=Poison.encode!(Usuario.get(usuario))
    {:ok,Usuario.post("/buyers",body)}
    IO.puts("Se ejecuto: obtener_subasta")
  end

  def obtener_subasta(usuario) when is_bitstring(usuario) do
    pid = get_pid_usuario(usuario)
    obtener_subasta(pid)
  end


  def crear_subasta(instance,tags,precioBase,tiempoFinalizacion,articuloNombre,articuloDescripcion) do
    usuario=Usuario.state(instance)
    subasta= Modelo.Subasta.new(usuario.id, tags,precioBase,tiempoFinalizacion,articuloNombre,articuloDescripcion)
    body=Poison.encode!(subasta)
    response=Usuario.post("/bids",body)
    IO.inspect(response, label: "crear_subasta")

  end

  def ofertar_subasta(instance,idSubasta,precioOfertado) do
    usuario=Usuario.state(instance)
    oferta= Modelo.OfertarSubasta.new(idSubasta,usuario.id,precioOfertado)
    body=Poison.encode!(oferta)
    response=Usuario.put("/bids",body)
    IO.inspect(response, label: "ofertar_subasta")

  end

  def cancelar_subasta(instance,idSubasta) do
    usuario=Usuario.state(instance)
    response=Usuario.delete("/bids/#{usuario.id}/#{idSubasta}")
    IO.inspect(response, label: "cancelar_subasta")

  end

end
