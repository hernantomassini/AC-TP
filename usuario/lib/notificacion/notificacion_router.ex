defmodule Notificacion.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)
  plug(:dispatch)

  #RECIBE UN Modelo.Subasta
  post "/subasta/ganador/" do
#    {:ok, body, conn} = read_body(conn)
#    body = Poison.decode!(body, as: %Modelo.Subasta{})
    send_resp(conn, 200, Response.new("","Muchas gracias por el articulo! :D"))
  end

  #RECIBE UN Modelo.Subasta
  post "/subasta/interes/:idUsuario" do
    if(Usuario.Registry.existe_usuario(idUsuario)) do

    {:ok, body, conn} = read_body(conn)
    subasta = Poison.decode!(body, as: %Modelo.Subasta{})
    Usuario.ejecutar_estrategia(idUsuario,subasta)
    send_resp(conn, 200, Response.new("","Me puede interesar"))
    else
      send_resp(conn, 200, Response.new("","No poseo usuarios interesados"))
    end
  end

  #RECIBE UN Modelo.Subasta
  post "/subasta/cancelacion/:idUsuario" do
#    {:ok, body, conn} = read_body(conn)
#    body = Poison.decode!(body, as: %Modelo.Subasta{})
    send_resp(conn, 200, Response.new("","Muchas gracias por el articulo! :D"))
  end

  # "Default" route that will get called when no other route is matched
  match _ do
    send_resp(conn, 404, "not found")
  end

end
