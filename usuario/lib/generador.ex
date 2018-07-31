defmodule Generador do
  @moduledoc false


  def crearUsuarioReintentos(user_id,cant_reintentos) do
    Generador.crearUsuarioReintentos(user_id, cant_reintentos, [])
  end


  def crearUsuarioReintentos(user_id, cant_reintentos, array_interes) do
    aumentar_precio=20
    estrategia= Modelo.Estrategia.reintentos(cant_reintentos,aumentar_precio)
    Generador.crearUsuario(user_id,array_interes,estrategia)
  end

  def crearUsuarioOfertarHasta(user_id, maximo_dinero,aumentar_oferta_en) do
    Generador.crearUsuarioOfertarHasta(user_id, maximo_dinero,aumentar_oferta_en,[])
  end

  def crearUsuarioOfertarHasta(user_id,maximo_dinero,aumentar_oferta_en,array_interes) do
    estrategia= Modelo.Estrategia.oferta_hasta(maximo_dinero,aumentar_oferta_en)
    Generador.crearUsuario(user_id,array_interes,estrategia)
  end

  def crearUsuario(user_id,array_interes,estrategia_oferta_reintentos) do
    usaurio= Modelo.Usuario.new(user_id, ["videojuegos","cosa2"]++array_interes, estrategia_oferta_reintentos)
    Usuario.Registry.crear_usuario(usaurio)
    pid_usuario = Usuario.Registry.get_pid_usuario(user_id)
    Usuario.registrar_usuario(pid_usuario)
    pid_usuario
  end



  def crearSubastaByUserId(user_id,precio,tiempo_subasta) do
    pid_usuario = Usuario.Registry.get_pid_usuario(user_id)
    Generador.crearSubastaByUserPid(pid_usuario,precio,tiempo_subasta)
  end

  def crearSubastaByUserPid(pid_usuario,precio,tiempo_subasta) do
    Usuario.crear_subasta(pid_usuario, ["perritos", "videojuegos","#{precio}"], precio, tiempo_subasta, "Articulo_ #{precio}:#{tiempo_subasta}", "Comprar - articulo de preciobase: #{precio}")
  end


  def start_50() do
    Generador.u_50()
    :timer.sleep(3000)
    Generador.sub_50()
  end

  def u_50() do
    (1..50) |> Enum.map(fn x -> Generador.crearUsuarioReintentos("usuario_reintento_#{x}", 4) end)
    (1..5) |> Enum.map(fn x -> Generador.crearUsuarioOfertarHasta("usuario_oferta_#{x}", 5000+x,300) end)

  end

  def sub_50() do

    (1..50) |> Enum.map(fn x -> Generador.crearSubastaByUserId("usuario_reintento_#{x}", 50+x, 30) end)
    (1..5) |> Enum.map(fn x -> Generador.crearSubastaByUserId("usuario_oferta_#{x}", x*2,40) end)
  end

#  def crearUsuarioReintentos(user_id,cant_reintentos) do
    #    aumentar_precio_usuario_test_1=20
    #    estrategia_oferta_reintentos= Modelo.Estrategia.reintentos(6,aumentar_precio_usuario_test_1)
    #    usaurio= Modelo.Usuario.new("usuarioTest", ["videojuegos","cosa2"], estrategia_oferta_reintentos)
    #    Usuario.Registry.crear_usuario(usaurio)
    #    pid_usuario = Usuario.Registry.get_pid_usuario(usaurio.id)
    #    Usuario.registrar_usuario(pid_usuario)
    #    pid_usuario
    #  end

#    #usuario_1_crea_subasta
#  def crearUsuarioReintentos(user_id,cant_reintentos) do
#    ##Se crea y se valida
#
##    aumentar_precio_usuario_test_1=20
##    estrategia_oferta_reintentos= Modelo.Estrategia.reintentos(6,aumentar_precio_usuario_test_1)
##    usaurio= Modelo.Usuario.new("usuarioTest", ["computacion","cosa2"], estrategia_oferta_reintentos)
##    Usuario.Registry.crear_usuario(usaurio)
##    pid_usuario = Usuario.Registry.get_pid_usuario(usaurio.id)
#    reintentos=6
#    aumentar_en=30
#    pid_usuario=crearUsuarioReintentos("usuarioTest",reintentos,aumentar_en)
#    Usuario.registrar_usuario(pid_usuario)
#
#    precio_articulo_1=45
#    tiempo_subasta_segundos=10
#    response =Usuario.crear_subasta(pid_usuario, ["perritos", "videojuegos"], precio_articulo_1, tiempo_subasta_segundos, "Articulo1", "Compralo que esta buenisimo")
#    IO.inspect(response.data, label: "subasta_creada_RESPONSE")
#    if response.error do raise "subasta_creada_RESPONSE con error"  end
#    subasta_creada = Response.data_to_subasta(response.data)
#    IO.inspect(subasta_creada, label: "subasta_creada")
#    response_consulta=Usuario.obtener_subasta(subasta_creada.id)
#    IO.inspect(response_consulta, label: "response_consulta")
#    if response_consulta.error do raise "response_consulta con error"  end
#
#    subasta_consulta=Response.data_to_subasta(response_consulta.data)
#    if !Modelo.Subasta.equals(subasta_creada, subasta_consulta) do raise "Las subastas generados no son iguales"  end
#
#  end
##usuario_2_crea_subasta_espera_oferta_de_usuario_1
#  def u2() do
#
#    estrategia_oferta_reintentos= Modelo.Estrategia.reintentos(3,20)
#    usaurio= Modelo.Usuario.new("usuario_test_2", ["computacion","perritos"], estrategia_oferta_reintentos)
#    Usuario.Registry.crear_usuario(usaurio)
#    pid_usuario = Usuario.Registry.get_pid_usuario(usaurio.id)
#    Usuario.registrar_usuario(pid_usuario)
##    precio_articulo=30
##    tiempo_subasta_segundos=10
##    response =Usuario.crear_subasta(pid_usuario, ["cosa2"], precio_articulo, tiempo_subasta_segundos, "ARTICULO_3", "Compralo que esta buenisimo")
#
#    #Espero para darle tiempo a que se ejecuten las ofertas por la notifiacion recibvida al genera la subasta
#    #Como la subasta nueva esta asociada also interes del primer usuario_test debe actualziarse la oferta de la subtas
##    response_consulta=Usuario.obtener_subasta(subasta_creada.id)
##    assert !response_consulta.error
##    subasta_consulta=Response.data_to_subasta(response_consulta.data)
##    IO.inspect(subasta_consulta, label: "response_consulta_usert_2")
#
##    assert subasta_consulta.precio == (precio_articulo_1+aumentar_precio_usuario_test_1)
#  end
end
