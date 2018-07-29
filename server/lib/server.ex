defmodule Server do
  @moduledoc false

  def crear_subasta(subasta_no_inicializada) do
    subasta = Modelo.Subasta.new(subasta_no_inicializada)
    GlobalContext.crear_subasta(subasta)

    Task.async(SubastaTask, :monitorear_subasta, [subasta.id])
    # TODO: Mandar a los usuarios que le interesen la subasta la notificación!!

    Response.new(subasta, "Se a creado una subasta correctamente.")
  end

  def registrar_usuario(usuario = %Modelo.Usuario{tags: tags}) do
    GlobalContext.registrar_usuario(usuario)
    send_subastas_de_interes(tags, "El usuario fue agregado con éxito.")
  end

  def obtener_subastas_de_interes(idUsuario) do
    user = GlobalContext.get_usuario(idUsuario)

    if user do
      {200, send_subastas_de_interes(user.tags, "Subastas de interes.")}
    else
      {404, Response.error(true, "El ID provisto no existe. Método obtener_subastas_de_interes con id #{idUsuario}")}
    end
  end

  def ofertar(idSubasta, idUsuario, valorOfertado) do
    subasta = GlobalContext.get_subasta(idSubasta)
    usuario = GlobalContext.get_usuario(idUsuario)

    cond do
      !subasta -> {404, Response.error(true, "El ID de la subasta no existe. Método ofertar con id #{idSubasta}")}
      !usuario -> {404, Response.error(true, "El ID del usuario no existe. Método ofertar con id #{idUsuario}")}
      subasta && usuario ->
        if valorOfertado > subasta.precio do
          subasta = put_in(subasta.precio, valorOfertado)
          GlobalContext.modificar_subasta(subasta)
          {200, "La oferta ha sido aceptada."}
        else
          {500, "El valor ofertado es demasiado bajo."}
        end
    end
  end

  defp send_subastas_de_interes(tags, msg) do
    subastas = GlobalContext.get_subastas()
    subastas_de_interes = Modelo.Usuario.subastas_de_interes(tags, subastas)
    Response.new(subastas_de_interes, msg)
  end
end
