defmodule SubastaTask do

  def monitorear_subasta(id_subasta) do
    :timer.sleep(1000)

    subasta = GlobalContext.get_subasta(id_subasta)

    if subasta.estado == :cancelada do
      notificar_cancelacion(subasta)
    end

    if subasta.tiempoFinalizacion != 0 do
      time = subasta.tiempoFinalizacion - 1
      newSubasta = put_in(subasta.tiempoFinalizacion, time)
      GlobalContext.modificar_subasta(newSubasta)
      monitorear_subasta(time)
    else
      notificar_terminacion(subasta)
    end
  end

  def notificar_terminacion(subasta) do
    # TODO: Notificarles a todos los que particiaron si ganaron o perdieron.
    kill_task()
  end

  def notificar_cancelacion(subasta) do
    # TODO: Notificarles a todos los que participaron que la subasta se canceló.
    kill_task()
  end

  def kill_task() do
    Process.exit(self(), :normal)
  end

end
