defmodule Persona.Test do
  @moduledoc false


  def get_pid() do
    #Se instancia
    #reintentos(cant_reintentos,sumar_al_precio)
    estrategia_oferta_reintentos= Modelo.Estrategia.reintentos(3,20)
    usaurio= Modelo.Usuario.new("usuarioTest", ["cosa1","cosa2"], estrategia_oferta_reintentos)
    Usuario.Registry.crear_usuario(usaurio)
    pid_usuario = Usuario.Registry.get_pid_usuario(usaurio.id)
  end
end
