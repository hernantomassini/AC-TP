defmodule SubastaTask do

  def monitorear_subasta(time) do
    IO.inspect(time, label: "monitorear subasta ejecuta con time")
    :timer.sleep(1000)

    # TODO: Modificar el time de la subasta del GlobalContext

    if time != 0 do
      monitorear_subasta(time - 1)
    else
      # TODO: Ver como dejar morir o matar a este proceso que ya termino su función
    end

  end

end
