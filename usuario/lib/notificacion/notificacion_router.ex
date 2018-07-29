defmodule Notificacion.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)
  plug(:dispatch)

  #RECIBE UN Modelo.Subasta
  post "/notificacion/ganador/:id_usuario" do
#    {:ok, body, conn} = read_body(conn)
#    body = Poison.decode!(body, as: %Modelo.Subasta{})
    send_resp(conn, 200, Response.new("","Muchas gracias por el articulo! :D"))
  end

  #RECIBE UN Modelo.Subasta
  post "/notificacion/interes/:id_usuario" do
    if(Usuario.Registry.existe_usuario(id_usuario)) do

    {:ok, body, conn} = read_body(conn)
    subasta = Poison.decode!(body, as: %Modelo.Subasta{})
    Usuario.ejecutar_estrategia(id_usuario,subasta)
    send_resp(conn, 200, Response.new("","Me puede interesar"))
    else
      send_resp(conn, 200, Response.new("","No poseo usuarios interesados"))
    end
  end

  post "/notificacion/perdedor/:id_usuario" do
    {:ok, body, conn} = read_body(conn)
    subasta = Poison.decode!(body, as: %Modelo.Subasta{})
    IO.puts("El usuario: #{id_usuario} perdio el articulo #{subasta.articulo_nombre} ante el GANADOR: #{subasta.id_usuario}}")
    send_resp(conn, 200, Response.new("","Que pena!! sera mas suerte para proxima."))
  end

  #RECIBE UN Modelo.Subasta
  post "/subasta/cancelacion/:id_usuario" do
#    {:ok, body, conn} = read_body(conn)
#    body = Poison.decode!(body, as: %Modelo.Subasta{})
    send_resp(conn, 200, Response.new("","Muchas gracias por el articulo! :D"))
  end

  # "Default" route that will get called when no other route is matched
  match _ do
    send_resp(conn, 404, "not found")
  end

end
