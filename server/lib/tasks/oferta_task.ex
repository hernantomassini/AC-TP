defmodule OfertaTask do

  def notificar_oferta(subasta) do
    # TODO: Notificar de la oferta a todos los participantes de la subasta
    kill_task()
  end

  defp kill_task() do
    Process.exit(self(), :normal)
  end

end
