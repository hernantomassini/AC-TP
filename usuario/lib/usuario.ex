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
  #Interacción con el Servidor

  @doc """
    Muestra subastas que el usuario encontrará de interes.
    GET /buyers/interests/:idUsuario
    Return: Subastas de interés
  """
  def subastas_de_interes(pidUsuario) when is_pid(pidUsuario) do
    usuario = Usuario.state(pidUsuario)
    response = Usuario.get("/buyers/interests/#{usuario.id}")
    IO.inspect(response, label: "subastas_de_interes")
  end

  def subastas_de_interes(idUsuario) when is_bitstring(idUsuario) do
    pid = get_pid_usuario(idUsuario)
    subastas_de_interes(pid)
  end

  @doc """
    Muestra subastas a las cuales el usuario ha ofertado.
    GET /buyers/owns/:idUsuario
    Return: Subastas las cuales el usuario ofertó.
  """
  def subastas_ofertadas(pidUsuario) when is_pid(pidUsuario) do
    usuario = Usuario.state(pidUsuario)
    response = Usuario.get("/buyers/owns/#{usuario.id}")
    IO.inspect(response, label: "subastas_ofertadas")
  end

  def subastas_ofertadas(idUsuario) when is_bitstring(idUsuario) do
    pid = get_pid_usuario(idUsuario)
    subastas_ofertadas(pid)
  end

  @doc """
    El usuario comienza una subasta de un artículo
    POST /bids
    Return: ID de la subasta
  """
  def crear_subasta(pidUser, tags, precio, tiempoFinalizacion, articuloNombre, articuloDescripcion) when is_pid(pidUser) do
    usuario = Usuario.state(pidUser)
    subasta = Modelo.Subasta.new(usuario.id, tags,precio, tiempoFinalizacion, articuloNombre, articuloDescripcion)
    body = Poison.encode!(subasta)
    Usuario.post("/bids", body)
  end

  def crear_subasta(idUser, tags, precio, tiempoFinalizacion, articuloNombre, articuloDescripcion) when is_bitstring(idUser) do
    pid = get_pid_usuario(idUser)
    crear_subasta(pid, tags, precio, tiempoFinalizacion, articuloNombre, articuloDescripcion)
  end

  @doc """
    Registra al usuario en el Servidor. El usuario estará interesado en las subastas que tengan al menos 1 tag del usuario.
    POST /buyers
    Return: Subastas de interés
  """
  def registrar_usuario(pidUsuario) when is_pid(pidUsuario) do
    estado_usuario=Usuario.state(pidUsuario)
    estado_usuario= %Modelo.Usuario{estado_usuario | pid_estrategia: nil} #No se debe evinar el objetivo #PID
    body = Poison.encode!(estado_usuario)
    response = Usuario.post("/buyers", body)
    IO.inspect(response, label: "registrar_usuario")
  end

  def registrar_usuario(idUsuario) when is_bitstring(idUsuario) do
    pid = get_pid_usuario(idUsuario)
    registrar_usuario(pid)
  end

  @doc """
    El usuario oferta en una subasta
    PUT /bids
    Return: 200 si la oferta fue aceptada. Caso contrario 500.
  """
  def ofertar_subasta(pidUser, idSubasta, valorOfertado) when is_pid(pidUser) do
    usuario = Usuario.state(pidUser)
    oferta = Modelo.OfertarSubasta.new(idSubasta, usuario.id, valorOfertado)
    body = Poison.encode!(oferta)
    Usuario.put("/bids", body)
    # IO.inspect(response, label: "ofertar_subasta")
  end

  def ofertar_subasta(idUser, idSubasta, valorOfertado) when is_bitstring(idUser) do
    pid = get_pid_usuario(idUser)
    ofertar_subasta(pid, idSubasta, valorOfertado)
  end

  @doc """
    El usuario cancela una subasta QUE HAYA SIDO GENERADA POR ÉL.
    DELETE /bids/:idUsuario/:idSubasta
    Return: 200 si la subasta fue cancelada. Caso contrario 500.
  """
  def cancelar_subasta(pidUser ,idSubasta) when is_pid(pidUser) do
    usuario = Usuario.state(pidUser)
    Usuario.delete("/bids/#{usuario.id}/#{idSubasta}")
  end

  def cancelar_subasta(idUser, idSubasta) when is_bitstring(idUser) do
    pid = get_pid_usuario(idUser)
    cancelar_subasta(pid, idSubasta)
  end

  def ejecutar_estrategia(idUser, idSubasta, valorOfertado) when is_bitstring(idUser) do
    pid = get_pid_usuario(idUser)
    ofertar_subasta(pid, idSubasta, valorOfertado)
  end
end
