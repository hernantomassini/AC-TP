defmodule SubastaTask do

  def monitorear_subasta(id_subasta) do
    :timer.sleep(1000)
    subasta = GlobalContext.get_subasta(id_subasta)

    IO.inspect(subasta.tiempo_finalizacion, label: "Duracion de subasta")

    if subasta.estado == :cancelada do
      notificar_subasta_cancelada(subasta)
    end

    if subasta.tiempo_finalizacion != 0 do
      Map.put(subasta, :tiempo_finalizacion, subasta.tiempo_finalizacion - 1) |> GlobalContext.modificar_subasta()
      monitorear_subasta(id_subasta)
    else
      subasta_terminada = Map.put(subasta, :estado, :terminada)
      GlobalContext.modificar_subasta(subasta_terminada)
      terminar_subasta(subasta_terminada)
    end
  end

  def notificar_subasta_cancelada(subasta) do
    # TODO: Notificarles a todos los que participaron que la subasta se canceló.
    kill_task()
  end

  defp terminar_subasta(subasta) do
    # TODO: Notificarles a todos los que particiaron si ganaron o perdieron.
    IO.inspect(subasta, label: "Subasta finalizada")
    kill_task()
  end

  defp kill_task() do
    Process.exit(self(), :normal)
  end

end
