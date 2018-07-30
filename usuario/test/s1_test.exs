
defmodule GanarSubasta1 do
  use ExUnit.Case, async: true

  @moduledoc false

#  setup do
#    pid_test_user=Persona.Test.get_pid()
#    %{pid_usuarioTest: pid_test_user}
#  end


#  test "Crear Subasta" do
#    ##Se crea y se valida
#    aumentar_precio_usuario_test_1=20
#    estrategia_oferta_reintentos= Modelo.Estrategia.reintentos(3,aumentar_precio_usuario_test_1)
#    usaurio= Modelo.Usuario.new("usuarioTest", ["computacion","cosa2"], estrategia_oferta_reintentos)
#    Usuario.Registry.crear_usuario(usaurio)
#    pid_usuario = Usuario.Registry.get_pid_usuario(usaurio.id)
#    precio_articulo_1=45
#    tiempo_subasta_segundos=10
#    response =Usuario.crear_subasta(pid_usuario, ["perritos", "videojuegos"], precio_articulo_1, tiempo_subasta_segundos, "Articulo1", "Compralo que esta buenisimo")
#    IO.inspect(response.data, label: "subasta_creada_RESPONSE")
#    assert !response.error
#    subasta_creada = Response.data_to_subasta(response.data)
#    IO.inspect(subasta_creada, label: "subasta_creada")
#    response_consulta=Usuario.obtener_subasta(subasta_creada.id)
#    IO.inspect(response_consulta, label: "response_consulta")
#    assert !response_consulta.error
#    subasta_consulta=Response.data_to_subasta(response_consulta.data)
#    assert Modelo.Subasta.equals(subasta_creada, subasta_consulta)
#
#
#    #SE REGISTRA UN SUAIRO YSE GENERA OTRA SUBASTA
#    estrategia_oferta_reintentos= Modelo.Estrategia.reintentos(3,20)
#    usaurio= Modelo.Usuario.new("usuario_test_2", ["computacion","perritos"], estrategia_oferta_reintentos)
#    Usuario.Registry.crear_usuario(usaurio)
#    pid_usuario = Usuario.Registry.get_pid_usuario(usaurio.id)
#    precio_articulo=30
#    tiempo_subasta_segundos=10
#    response =Usuario.crear_subasta(pid_usuario, ["cosa2"], precio_articulo, tiempo_subasta_segundos, "ARTICULO_3", "Compralo que esta buenisimo")
#    subasta_creada_test_2=Response.data_to_subasta(response_consulta.data)
#    :timer.sleep(5000)
#    #Espero para darle tiempo a que se ejecuten las ofertas por la notifiacion recibvida al genera la subasta
#    #Como la subasta nueva esta asociada also interes del primer usuario_test debe actualziarse la oferta de la subtas
#    response_consulta=Usuario.obtener_subasta(subasta_creada.id)
#    assert !response_consulta.error
#    subasta_consulta=Response.data_to_subasta(response_consulta.data)
#    IO.inspect(subasta_consulta, label: "response_consulta_usert_2")
#
#    assert subasta_consulta.precio == (precio_articulo_1+aumentar_precio_usuario_test_1)
#
#    :timer.sleep(30)
#  end

#  test "HERNAN oferta" do
#      Persona.Hernan.start()
#
#  end



end


