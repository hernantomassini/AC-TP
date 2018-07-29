defmodule OfertaTask do

  def notificar_oferta(subasta) do

    kill_task()
  end

  defp kill_task() do
    Process.exit(self(), :normal)
  end

end
