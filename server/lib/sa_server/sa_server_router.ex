defmodule SaServer.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)
  plug(:dispatch)

  post "/bids" do
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body)
    SaServer.crear_subasta(body)
    send_resp(conn, 201, "created: #{get_in(body, ["message"])}")
  end

  post "/buyers" do
    {:ok, body, conn} = read_body(conn)
    body = Poison.decode!(body, as: %Comprador{})
    response = SaServer.agregar_comprador(body)
    send_resp(conn, 201, response)
  end

  # "Default" route that will get called when no other route is matched
  match _ do
    send_resp(conn, 404, "not found")
  end

end
