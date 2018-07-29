defmodule Server.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)
  plug(:dispatch)

  get "/buyers/interests/:id_usuario" do
    {httpCode, response} = Server.obtener_subastas_de_interes(id_usuario)
    send_resp(conn, httpCode, response)
  end

  get "/buyers/owns/:id_usuario" do
    # {:ok, body, conn} = read_body(conn)
    # body = Poison.decode!(body, as: %SubastaById{})
    # response = Server.todo_function_not_implemented(id, body)
    send_resp(conn, 200, "Se consultas las subastas propias #{id_usuario}")
  end

  get "/replicar" do
    # {:ok, body, conn} = read_body(conn)
    # body = Poison.decode!(body)
    # response = Server.todo_function_not_implemented(id, body)
    send_resp(conn, 200, "Se realizo la replicacion")
  end

  post "/bids" do
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body, as: %Modelo.Subasta{})
    response = Server.crear_subasta(body)
    send_resp(conn, 201, response)
  end

  post "/buyers" do
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body, as: %Modelo.Usuario{})
    response = Server.registrar_usuario(body)
    send_resp(conn, 201, response)
  end

  put "/bids" do
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body, as: %Modelo.Oferta{})
    {httpCode, response} = Server.ofertar(body)
    send_resp(conn, httpCode, response)
  end

  delete "/bids/:id_usuario/:id_subasta" do
    response = Server.cancelar_subasta(id_usuario, id_subasta)
    send_resp(conn, 200, response)
  end

  match "/" do
    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

end
