defmodule Persona.Hernan do
  @moduledoc false


  def start() do
    #Se instancia
    #reintentos(cant_reintentos,sumar_al_precio)
    estrategia_oferta= Modelo.Estrategia.oferta_hasta(300,100)
    usaurio= Modelo.Usuario.new("hernan", ["computacion","perritos"], estrategia_oferta)
    Usuario.Registry.crear_usuario(usaurio)
    pidUsuario = Usuario.Registry.get_pid_usuario(usaurio.id)
    #Se registra
    Usuario.registrar_usuario(pidUsuario)
    pidUsuario
  end
end
