

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

  def state(instance) do
    Agent.get(instance, &Map.get(&1, "state"))
  end

  def save(instance, value) do
    Agent.update(instance, &Map.put(&1, "state", value))
  end

  #------------------------------------------------------------------------------
  #COMPORTAMIENTO DE INTERACCIÓN CON SERVIDOR

  @doc """
    Registra al usuario en el Servidor. El usuario estará interesado en las subastas que tengan al menos 1 tag del usuario.
    POST /buyers
  """
  def registrar_usuario(pidUsuario) when is_pid(pidUsuario) do
    body = Poison.encode!(Usuario.state(pidUsuario))
    response = Usuario.post("/buyers", body)
    IO.inspect(response.body,label: "registrar_usuario")
  end

  def registrar_usuario(idUsuario) when is_bitstring(idUsuario) do
    pid = get_pid_usuario(idUsuario)
    registrar_usuario(pid)
  end

  @doc """
    Muestra subastas a las cuales el usuario ha ofertado.
    GET /buyers/:idUsuario
  """
  def consultar_subastas_ofertadas(pidUsuario) when is_pid(pidUsuario) do
    usuario = Usuario.state(pidUsuario)
    response = Usuario.get("/buyers/#{usuario.id}")
    IO.inspect(response, label: "consultar_subastas_ofertadas")
  end

  def consultar_subastas_ofertadas(idUsuario) when is_bitstring(idUsuario) do
    pid = get_pid_usuario(idUsuario)
    consultar_subastas_ofertadas(pid)
  end

  @doc """
    TODO: METER ALGO INTELIGENTE AAAAAAAAAAAAAA
    POST /bids
  """
  def crear_subasta(pidUser, tags, precioBase, tiempoFinalizacion, articuloNombre, articuloDescripcion) when is_pid(pidUser) do
    usuario = Usuario.state(pidUser)
    subasta = Modelo.Subasta.new(usuario.id, tags,precioBase, tiempoFinalizacion, articuloNombre, articuloDescripcion)
    body = Poison.encode!(subasta)
    Usuario.post("/bids", body)
  end

  def crear_subasta(idUser, tags, precioBase, tiempoFinalizacion, articuloNombre, articuloDescripcion) when is_bitstring(idUser) do
    pid = get_pid_usuario(idUser)
    crear_subasta(pid, tags, precioBase, tiempoFinalizacion, articuloNombre, articuloDescripcion)
  end

  @doc """
    TODO: METER ALGO INTELIGENTE AAAAAAAAAAAAAA
    PUT /bids
  """
  def ofertar_subasta(instance, idSubasta, precioOfertado) do
    usuario = Usuario.state(instance)
    oferta = Modelo.OfertarSubasta.new(idSubasta, usuario.id, precioOfertado)
    body = Poison.encode!(oferta)
    Usuario.put("/bids", body)
  end


  @doc """
    TODO: METER ALGO INTELIGENTE AAAAAAAAAAAAAA
    DELETE /bids/:idUsuario/:idSubasta
  """
  def cancelar_subasta(instance,idSubasta) do
    usuario = Usuario.state(instance)
    Usuario.delete("/bids/#{usuario.id}/#{idSubasta}")
  end

end
