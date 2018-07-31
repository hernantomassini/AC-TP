defmodule Sincronizar do
  use HTTPoison.Base

  def execute() do
    IO.puts("Se ejecuto el Sincronizar.execute()")
    estado = GlobalContext.export_estado()
    url = AdminContext.get_host()
    Sincronizar.post(url<>"/sincronizar", Poison.encode!(estado))
  end

end
