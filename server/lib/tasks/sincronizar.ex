defmodule Sincronizar do
  use HTTPoison.Base

  def execute() do
    estado = GlobalContext.export_estado()
    url = AdminContext.get_host()
    Sincronizar.post(url, Poison.encode!(estado))
  end

end
