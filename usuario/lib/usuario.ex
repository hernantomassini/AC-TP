defmodule Modelo.Usuario do
  @moduledoc false
  @derive [Poison.Encoder]
  defstruct [:id,:ip,:puerto,:tags]
end

defmodule Usuario do
  @moduledoc false
  use HTTPoison.Base
  import Usuario.Registry, only: [get_pid_usuario: 1]

  @endpoint "http://127.0.0.1:8085"

  def process_url(url) do
    @endpoint <> url
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
    IO.inspect(response)
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
    IO.inspect(response)
  end


  def obtener_subasta(usuario) when is_pid(usuario) do
    body=Poison.encode!(Usuario.get(usuario))
    {:ok,Usuario.post("/buyers",body)}
    IO.puts("ejecutado post")
  end

  def obtener_subasta(usuario) when is_bitstring(usuario) do
    pid = get_pid_usuario(usuario)
    obtener_subasta(pid)
  end


  def crear_subasta(instance,tags,precioBase,tiempoFinalizacion,articuloNombre,articuloDescripcion) do
    usuario=Usuario.state(instance)
    subasta= Modelo.Subasta.new(usuario.id, tags,precioBase,tiempoFinalizacion,articuloNombre,articuloDescripcion)
    body=Poison.encode!(subasta)
    Usuario.post("/bids",body)
  end

  def ofertar_subasta(instance,idSubasta,precioOfertado) do
    usuario=Usuario.state(instance)
    oferta= Modelo.OfertarSubasta.new(idSubasta,usuario.id,precioOfertado)
    body=Poison.encode!(oferta)
    Usuario.put("/bids",body)
  end

  def cancelar_subasta(instance,idSubasta) do
    usuario=Usuario.state(instance)
    Usuario.delete("/bids/#{usuario.id}/#{idSubasta}")
  end

end
