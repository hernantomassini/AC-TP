defmodule Server.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)
  plug(:dispatch)

  get "/bids" do
    if GlobalContext.is_active() do
      {:ok, _, conn} = read_body(conn)
      response=Response.new(GlobalContext.get_subastas(), "Todas las subastas del server")
      send_resp(conn, 201, response)
    else
      send_resp(conn, 500, "El servidor todavía no se sincronizo con el cliente - no acepta requests")
    end
  end

  get "/bids/:id_subasta" do
    if GlobalContext.is_active() do
      {httpCode, response} = Server.obtener_subasta(id_subasta)
      send_resp(conn, httpCode, response)
    else
      send_resp(conn, 500, "El servidor todavía no se sincronizo con el cliente - no acepta requests")
    end
  end

  get "/buyers/interests/:id_usuario" do
    if GlobalContext.is_active() do
      response = Server.obtener_subastas_de_interes(id_usuario)
      send_resp(conn, 200, response)
    else
      send_resp(conn, 500, "El servidor todavía no se sincronizo con el cliente - no acepta requests")
    end
  end

  get "/buyers/owns/:id_usuario" do
    if GlobalContext.is_active() do
      {httpCode, response} = Server.obtener_subastas_ofertadas(id_usuario)
      send_resp(conn, httpCode, response)
    else
      send_resp(conn, 500, "El servidor todavía no se sincronizo con el cliente - no acepta requests")
    end
  end

  post "/replicar" do
    send_resp(conn, 200, Poison.encode!(GlobalContext.export_estado()))
  end

  post "/sincronizar" do
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body, as: %GlobalContext{})
    GlobalContext.import_estado(body)
    send_resp(conn, 200, "")
  end

  post "/bids" do
    if GlobalContext.is_active() do
      {:ok, body, conn} = read_body(conn)
      body = Poison.decode!(body, as: %Modelo.Subasta{})
      response = Server.crear_subasta(body)
      send_resp(conn, 201, response)
    else
      send_resp(conn, 500, "El servidor todavía no se sincronizo con el cliente - no acepta requests")
    end
  end

  post "/buyers" do
    if GlobalContext.is_active() do
      {:ok, body, conn} = read_body(conn)
      body = Poison.decode!(body, as: %Modelo.Usuario{})
      response = Server.registrar_usuario(body)
      send_resp(conn, 201, response)
    else
      send_resp(conn, 500, "El servidor todavía no se sincronizo con el cliente - no acepta requests")
    end
  end

  put "/bids" do
    if GlobalContext.is_active() do
      {:ok, body, conn} = read_body(conn)
      body = Poison.decode!(body, as: %Modelo.Oferta{})
      {httpCode, response} = Server.ofertar(body)
      send_resp(conn, httpCode, response)
    else
      send_resp(conn, 500, "El servidor todavía no se sincronizo con el cliente - no acepta requests")
    end
  end

  delete "/bids/:id_usuario/:id_subasta" do
    if GlobalContext.is_active() do
      {httpCode, response} = Server.cancelar_subasta(id_usuario, id_subasta)
      send_resp(conn, httpCode, response)
    else
      send_resp(conn, 500, "El servidor todavía no se sincronizo con el cliente - no acepta requests")
    end
  end

  match "/" do
    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

end
