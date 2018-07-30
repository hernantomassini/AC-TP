defmodule AdministradorTask do
  use HTTPoison.Base

  def inicializar(name, ip, port, ip_admin, port_admin) do
    body = %{"name" => name, "host" => ip <> ":" <> port, "weight" => 3}
    body = Poison.encode!(body)

    url_admin = ip_admin <> ":" <> port_admin
    AdministradorTask.post(url_admin <> "/inicializar", body)
    response = AdministradorTask.post(url_admin <> "/replicar", body)

    IO.inspect(response, label: "response")
    kill_task()
  end

  defp kill_task() do
    Process.exit(self(), :normal)
  end

end
