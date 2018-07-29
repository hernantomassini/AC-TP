defmodule SubastaTask do

  def monitorear_subasta(id_subasta) do
    :timer.sleep(1000)
    subasta = GlobalContext.get_subasta(id_subasta)

    IO.inspect(subasta.tiempoFinalizacion, label: "Duracion de subasta")

    if subasta.estado == :cancelada do
      cancelar_subasta(subasta)
    end

    if subasta.tiempoFinalizacion != 0 do
      time = subasta.tiempoFinalizacion - 1
      newSubasta = put_in(subasta.tiempoFinalizacion, time)
      GlobalContext.modificar_subasta(newSubasta)
      monitorear_subasta(id_subasta)
    else
      terminar_subasta(subasta)
    end
  end

  defp terminar_subasta(subasta) do
    # TODO: Notificarles a todos los que particiaron si ganaron o perdieron.
    IO.inspect(subasta.id, label: "Resultados de la subasta")
    IO.inspect(subasta.idGanador, label: "El ganador es")
    IO.inspect(subasta.precio, label: "con un valor a pagar de")
    IO.inspect(subasta.participantes, label: "Estos usuarios participaron de la subasta")
    kill_task()
  end

  defp cancelar_subasta(subasta) do
    # TODO: Notificarles a todos los que participaron que la subasta se canceló.
    kill_task()
  end

  defp kill_task() do
    Process.exit(self(), :normal)
  end

end
