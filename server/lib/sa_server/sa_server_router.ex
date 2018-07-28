defmodule SaServer.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)
  plug(:dispatch)

  post "/buyers" do
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body, as: %Modelo.Usuario{})
    response = SaServer.agregar_usuario(body)
    send_resp(conn, 201, response)
  end

  get "/buyers/:id" do
    response = SaServer.get_by_buyer(id)
    send_resp(conn, 200, response)
  end

  delete "/bids/:idUsuario/:idSubsata" do
    response = SaServer.delete_subasta(idUsuario,idSubsata)
    send_resp(conn, 200, response)
  end

  post "/bids" do
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body, as: %Modelo.Subasta{})
    response =  SaServer.crear_subasta(body)
    send_resp(conn, 201, response)
  end

  get "/bids/:id" do
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body, as: %SubastaById{})
    response = SaServer.post_subasta_by(id, body)
    send_resp(conn, 200, response)
  end

  # "Default" route that will get called when no other route is matched
  match _ do
    send_resp(conn, 404, "not found")
  end

end
