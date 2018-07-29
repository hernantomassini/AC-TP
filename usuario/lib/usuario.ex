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
    Retorna el estado de una subasta
    GET /bids/:id_subasta
    Return: Subasta
  """
  def obtener_subasta(id_subasta) do
    response = Usuario.get("/bids/#{id_subasta}")
    IO.inspect(response, label: "subastas_de_interes")
  end

  @doc """
    Muestra subastas que el usuario encontrará de interes.
    GET /buyers/interests/:id_usuario
    Return: Subastas de interés
  """
  def subastas_de_interes(pid_usuario) when is_pid(pid_usuario) do
    usuario = Usuario.state(pid_usuario)
    response = Usuario.get("/buyers/interests/#{usuario.id}")
    IO.inspect(response, label: "subastas_de_interes")
  end

  def subastas_de_interes(id_usuario) when is_bitstring(id_usuario) do
    pid = get_pid_usuario(id_usuario)
    subastas_de_interes(pid)
  end

  @doc """
    Muestra subastas a las cuales el usuario ha ofertado.
    GET /buyers/owns/:id_usuario
    Return: Subastas las cuales el usuario ofertó.
  """
  def subastas_ofertadas(pid_usuario) when is_pid(pid_usuario) do
    usuario = Usuario.state(pid_usuario)
    response = Usuario.get("/buyers/owns/#{usuario.id}")
    IO.inspect(response, label: "subastas_ofertadas")
  end

  def subastas_ofertadas(id_usuario) when is_bitstring(id_usuario) do
    pid = get_pid_usuario(id_usuario)
    subastas_ofertadas(pid)
  end

  @doc """
    El usuario comienza una subasta de un artículo
    POST /bids
    Return: ID de la subasta
  """
  def crear_subasta(pidUser, tags, precio, tiempo_finalizacion, articulo_nombre, articulo_descripcion) when is_pid(pidUser) do
    usuario = Usuario.state(pidUser)
    subasta = Modelo.Subasta.new(usuario.id, tags,precio, tiempo_finalizacion, articulo_nombre, articulo_descripcion)
    body = Poison.encode!(subasta)
    Usuario.post("/bids", body)
  end

  def crear_subasta(idUser, tags, precio, tiempo_finalizacion, articulo_nombre, articulo_descripcion) when is_bitstring(idUser) do
    pid = get_pid_usuario(idUser)
    crear_subasta(pid, tags, precio, tiempo_finalizacion, articulo_nombre, articulo_descripcion)
  end

  @doc """
    Registra al usuario en el Servidor. El usuario estará interesado en las subastas que tengan al menos 1 tag del usuario.
    POST /buyers
    Return: Subastas de interés
  """
  def registrar_usuario(pid_usuario) when is_pid(pid_usuario) do
    estado_usuario=Usuario.state(pid_usuario)
    estado_usuario= %Modelo.Usuario{estado_usuario | pid_estrategia: nil} #No se debe evinar el objetivo #PID
    body = Poison.encode!(estado_usuario)
    response = Usuario.post("/buyers", body)
    IO.inspect(response, label: "registrar_usuario")
  end

  def registrar_usuario(id_usuario) when is_bitstring(id_usuario) do
    pid = get_pid_usuario(id_usuario)
    registrar_usuario(pid)
  end

  @doc """
    El usuario oferta en una subasta
    PUT /bids
    Return: 200 si la oferta fue aceptada. 404 si el ID no existe. Caso contrario 500.
  """
  def ofertar_subasta(pidUser, id_subasta, valor_ofertado) when is_pid(pidUser) do
    usuario = Usuario.state(pidUser)
    oferta = Modelo.OfertarSubasta.new(id_subasta, usuario.id, valor_ofertado)
    body = Poison.encode!(oferta)
    Usuario.put("/bids", body)
  end

  def ofertar_subasta(idUser, id_subasta, valor_ofertado) when is_bitstring(idUser) do
    pid = get_pid_usuario(idUser)
    Response.decode(ofertar_subasta(pid, id_subasta, valor_ofertado))
  end

  @doc """
    El usuario cancela una subasta QUE HAYA SIDO GENERADA POR ÉL.
    DELETE /bids/:id_usuario/:id_subasta
    Return: 200 si la subasta fue cancelada. Caso contrario 500.
  """
  def cancelar_subasta(pidUser ,id_subasta) when is_pid(pidUser) do
    usuario = Usuario.state(pidUser)
    Usuario.delete("/bids/#{usuario.id}/#{id_subasta}")
  end

  def cancelar_subasta(idUser, id_subasta) when is_bitstring(idUser) do
    pid = get_pid_usuario(idUser)
    cancelar_subasta(pid, id_subasta)
  end

  def ejecutar_estrategia(idUser, subasta) when is_bitstring(idUser) do
    pidUser = get_pid_usuario(idUser)
    usuario = Usuario.state(pidUser)
    GenServer.cast(usuario.pid_estrategia, {:ejecutar, idUser,subasta})
  end
end
