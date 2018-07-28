defmodule Server do
  @moduledoc false
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [subastas: MapSet.new(), usuarios: MapSet.new()] end, name: __MODULE__)
  end

  # type es un átomo :subastas o :usuarios
  defp get(type) when is_atom(type) do
    Agent.get(__MODULE__, fn list -> Keyword.get(list, type) end)
  end

  defp put(type, value) when is_atom(type) do
    Agent.update(__MODULE__, fn list -> put_in(list[type], MapSet.put(list[type], value)) end)
  end

  #-------------------------

  def crear_subasta(subasta = %Modelo.Subasta{}) do
    put(:subastas, subasta)
    IO.inspect(get(:subastas), label: "Lista de usuarios")
    Response.new(subasta, "Se a creado una subasta correctamente.")
  end

  def registrar_usuario(usuario = %Modelo.Usuario{tags: tags}) do
    put(:usuarios, usuario)
    IO.inspect(get(:usuarios), label: "Lista de usuarios")
    send_subastas_de_interes(tags)
  end

  def obtener_subastas_de_interes(idUsuario) do
    user = get_user_by_id(idUsuario)

    if user do
      {200, send_subastas_de_interes(user.tags)}
    else
      {404, Response.error(true, "El ID provisto no existe. Método get_by_buyer con id #{idUsuario}")}
    end

  end

  defp send_subastas_de_interes(tags) do
    subastas_de_interes = Modelo.Usuario.subastas_de_interes(tags, get(:subastas))
    Response.new(subastas_de_interes, "El usuario fue agregado con éxito.")
  end

  defp get_user_by_id(id) do
    Enum.find(get(:usuarios), fn u -> String.downcase(u.id) === String.downcase(id) end)
  end
end
