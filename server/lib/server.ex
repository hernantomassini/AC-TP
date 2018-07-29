defmodule Server do
  @moduledoc false

  def crear_subasta(subasta_no_inicializada) do
    subasta = Modelo.Subasta.new(subasta_no_inicializada)
    GlobalContext.crear_subasta(subasta)

    IO.inspect(subasta.id, label: "subasta creada")
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

  def ofertar(%Modelo.Oferta{idSubasta: idSubasta, idUsuario: idUsuario, valorOfertado: valorOfertado}) do
    subasta = GlobalContext.get_subasta(idSubasta)

    cond do
      !subasta -> {404, Response.error(true, "El ID de la subasta no existe. Método ofertar con id #{idSubasta}")}
      String.downcase(subasta.idUsuario) === String.downcase(idUsuario) -> {500, "No podes ofertar en una subasta creada por vos mismo."}
      valorOfertado <= subasta.precio -> {500, "El valor ofertado es demasiado bajo."}
      true ->
        subasta = Map.put(subasta, :precio, valorOfertado)
          |> Map.put(:idGanador, idUsuario)
          |> Map.put(:participantes, [ idUsuario | subasta.participantes] |> Enum.uniq())

        GlobalContext.modificar_subasta(subasta)
        Task.async(OfertaTask, :notificar_oferta, [subasta])

        {200, "La oferta ha sido aceptada."}
    end
  end

  def cancelar_subasta(idUsuario, idSubasta) do
    subasta = GlobalContext.get_subasta(idSubasta)

    cond do
      !subasta -> {404, Response.error(true, "El ID de la subasta no existe. Método ofertar con id #{idSubasta}")}
      String.downcase(subasta.idUsuario) !== String.downcase(idUsuario) -> {500, Response.error(true, "No podes cancelar la subasta si no sos el creador de la misma.")}
      true ->
        subasta = Map.put(subasta, :estado, :cancelada)
        GlobalContext.modificar_subasta(subasta)

        Task.async(SubastaTask, :notificar_subasta_cancelada, [subasta])
        {200, "La subasta ha sido cancelada."}
    end

  end

  defp send_subastas_de_interes(tags, msg) do
    subastas = GlobalContext.get_subastas()
    subastas_de_interes = Modelo.Usuario.subastas_de_interes(tags, subastas)
    Response.new(subastas_de_interes, msg)
  end
end
