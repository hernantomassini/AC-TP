defmodule Server do
  @moduledoc false

  def crear_subasta(subasta_no_inicializada) do
    subasta = Modelo.Subasta.new(subasta_no_inicializada)
    GlobalContext.crear_subasta(subasta)

    IO.inspect(subasta.id, label: "subasta creada")
    Task.async(SubastaTask, :monitorear_subasta, [subasta.id])
    Task.async(NotificarTask, :nueva_subasta, [subasta])

    Response.new(subasta, "Se a creado una subasta correctamente.")
  end

  def registrar_usuario(usuario = %Modelo.Usuario{tags: tags}) do
    GlobalContext.registrar_usuario(usuario)
    send_subastas_de_interes(tags, "El usuario fue agregado con éxito.")
  end

  def obtener_subasta(id_subasta) do
    subasta = GlobalContext.get_subasta(id_subasta)

    if subasta
      do {200, Response.new(subasta, "Subasta encontrada.")}
      else {404, Response.error("No existe una subasta con el ID provisto.")}
    end
  end

  def obtener_subastas_ofertadas(id_usuario) do
    subastas = GlobalContext.get_subastas() |> Enum.filter(fn x -> Enum.member?(Enum.map(x.participantes, fn y -> String.downcase(y) end), String.downcase(id_usuario)) end)
    Response.new(subastas, "Subastas de interes")
  end

  def obtener_subastas_de_interes(id_usuario) do
    user = GlobalContext.get_usuario(id_usuario)

    if user
      do {200, send_subastas_de_interes(user.tags, "Subastas de interes.")}
      else {404, Response.error("El ID provisto no existe. Método obtener_subastas_de_interes con id #{id_usuario}")}
    end
  end

  def ofertar(%Modelo.Oferta{id_subasta: id_subasta, id_usuario: id_usuario, valor_ofertado: valor_ofertado}) do
    subasta = GlobalContext.get_subasta(id_subasta)

    cond do
      !subasta -> {404, Response.error("El ID de la subasta no existe. Método ofertar con id #{id_subasta}")}
      String.downcase(subasta.id_usuario) === String.downcase(id_usuario) -> {500, Response.error("No podes ofertar en una subasta creada por vos mismo.")}
      valor_ofertado <= subasta.precio -> {500, Response.error("El valor ofertado es demasiado bajo.")}
      true ->
        subasta = Map.put(subasta, :precio, valor_ofertado)
          |> Map.put(:id_ganador, id_usuario)
          |> Map.put(:participantes, [ id_usuario | subasta.participantes] |> Enum.uniq())

        GlobalContext.modificar_subasta(subasta)
        Task.async(NotificarTask, :nueva_oferta, [subasta])

        {200, Response.new("La oferta ha sido aceptada.")}
    end
  end

  def cancelar_subasta(id_usuario, id_subasta) do
    subasta = GlobalContext.get_subasta(id_subasta)

    cond do
      !subasta -> {404, Response.error("El ID de la subasta no existe. Método ofertar con id #{id_subasta}")}
      String.downcase(subasta.id_usuario) !== String.downcase(id_usuario) -> {500, Response.error("No podes cancelar la subasta si no sos el creador de la misma.")}
      true ->
        subasta = Map.put(subasta, :estado, :cancelada)
        GlobalContext.modificar_subasta(subasta)

        Task.async(NotificarTask, :subasta_cancelada, [subasta])
        {200, Response.new("La subasta ha sido cancelada.")}
    end

  end

  defp send_subastas_de_interes(tags, msg) do
    subastas = GlobalContext.get_subastas()
    subastas_de_interes = Modelo.Usuario.subastas_de_interes(tags, subastas)
    Response.new(subastas_de_interes, msg)
  end
end
