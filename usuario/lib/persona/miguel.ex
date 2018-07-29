defmodule Persona.Miguel do
  @moduledoc false


  def start() do
    #Se instancia
    #reintentos(cant_reintentos,sumar_al_precio)
    estrategia_oferta_reintentos= Modelo.Estrategia.reintentos(3,20)
    usaurio= Modelo.Usuario.new("miguel", ["computacion","perritos"], estrategia_oferta_reintentos)
    Usuario.Registry.crear_usuario(usaurio)
    pid_usuario = Usuario.Registry.get_pid_usuario(usaurio.id)
    #Se registra
    Usuario.registrar_usuario(pid_usuario)
    pid_usuario
  end
end
