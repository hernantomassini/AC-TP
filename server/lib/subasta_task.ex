defmodule SubastaTask do

  def monitorear_subasta(id_subasta) do
    :timer.sleep(1000)

    subasta = GlobalContext.get_subasta(id_subasta)
    # TODO: Analizar que su estado sea Activo. Si posee estado Cancelado tirar notificar_cancelacion.
    x = 1
    if x != 1 do
      notificar_cancelacion()
      kill_task()
    end

    time = 0
    # TODO: Modificar el time de la subasta del GlobalContext
    if time != 0 do
      monitorear_subasta(time - 1)
    else
      notificar_terminacion()
      kill_task()
    end

  end

  def notificar_terminacion() do

  end

  def notificar_cancelacion() do

  end

  def kill_task() do
    Process.exit(self(), :normal)
  end

end
