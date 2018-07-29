defmodule Server do
  @moduledoc false

  def crear_subasta(subasta = %Modelo.Subasta{id: id}) do
    subasta = Modelo.Subasta.initialize(subasta)
    GlobalContext.crear_subasta(subasta)

    Task.async(SubastaTask, :monitorear_subasta, [id])
    # TODO: Mandar a los usuarios que le interesen la subasta la notificación!!

    Response.new(subasta, "Se a creado una subasta correctamente.")
  end

  def registrar_usuario(usuario = %Modelo.Usuario{tags: tags}) do
    GlobalContext.registrar_usuario(usuario)
    send_subastas_de_interes(tags, "El usuario fue agregado con éxito.")
  end

  def obtener_subastas_de_interes(idUsuario) do
    user = get_user_by_id(idUsuario)

    if user do
      {200, send_subastas_de_interes(user.tags, "Subastas de interes.")}
    else
      {404, Response.error(true, "El ID provisto no existe. Método get_by_buyer con id #{idUsuario}")}
    end

  end

  defp send_subastas_de_interes(tags, msg) do
    subastas = GlobalContext.get_subastas()
    subastas_de_interes = Modelo.Usuario.subastas_de_interes(tags, subastas)
    Response.new(subastas_de_interes, msg)
  end

  defp get_user_by_id(id) do
    usuarios = GlobalContext.get_usuarios()
    Enum.find(usuarios, fn u -> String.downcase(u.id) === String.downcase(id) end)
  end
end
