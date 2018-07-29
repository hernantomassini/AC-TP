defmodule NotificarTask do
  use HTTPoison.Base

  def subasta_terminada(subasta) do
    body = Poison.encode!(subasta)

    url = get_url(subasta.id_usuario) <> "/notificacion"
    NotificarTask.post(url <> "/finalizada/#{subasta.id_usuario}", body)

    Enum.reject(subasta.participantes, fn x -> Modelo.Usuario.compare_id(x, subasta.id_usuario) end) |>
    Enum.map(fn id_usuario ->
      url = get_url(id_usuario) <> "/notificacion"

      if Modelo.Usuario.compare_id(id_usuario, subasta.id_ganador)
        do NotificarTask.post(url <> "/ganador/#{id_usuario}", body)
        else NotificarTask.post(url <> "/perdedor/#{id_usuario}", body)
      end

    end)

    kill_task()
  end

  def subasta_cancelada(subasta) do
    body = Poison.encode!(subasta)

    Enum.map([subasta.id_usuario | subasta.participantes], fn id_usuario ->
      url = get_url(id_usuario) <> "/subasta/cancelacion/#{id_usuario}"
      NotificarTask.post(url, body)
    end)

    kill_task()
  end

  def nueva_subasta(subasta) do
    body = Poison.encode!(subasta)
    usuarios = GlobalContext.get_usuarios()

    Enum.filter(usuarios, fn u -> length(Modelo.Usuario.subastas_de_interes(u.tags, [subasta])) > 0 end) |>
    Enum.map(fn u ->
      url = get_url(u.id_usuario) <> "/notificacion/interes/#{u.id_usuario}"
      NotificarTask.post(url, body)
    end)

    kill_task()
  end

  def nueva_oferta(subasta) do
    body = Poison.encode!(subasta)

    Enum.map(subasta.participantes, fn id_usuario ->
      url = get_url(id_usuario) <> "/notificacion"
      NotificarTask.post(url <> "/oferta/#{id_usuario}", body)
    end)

    kill_task()
  end

  defp get_url(id_usuario) do
    usuario = GlobalContext.get_usuario(id_usuario)
    "#{usuario.ip}:#{usuario.puerto}"
  end

  defp kill_task() do
    Process.exit(self(), :normal)
  end

end
