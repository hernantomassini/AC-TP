defmodule AdministradorTask do
  use HTTPoison.Base

  def inicializar(name, ip, port, ip_admin, port_admin) do
    :timer.sleep(3000)

    body = %{"name" => name, "host" => ip <> ":" <> port, "weight" => 3}
    body = Poison.encode!(body)

    url_admin = ip_admin <> ":" <> port_admin
    inicializarResponse = AdministradorTask.post(url_admin <> "/inicializar", body)

    IO.puts("Intentando conectar con el administrador...")

    case inicializarResponse do
      {:ok, _} -> :ok
      {:error, _} -> inicializar(name, ip, port, ip_admin, port_admin)
    end

    replicarResponse = AdministradorTask.post(url_admin <> "/replicar", body)

    x =
      case replicarResponse do
        {:ok, response} -> Poison.decode!(response.body, as: %GlobalContext{})
        {:error, _} -> inicializar(name, ip, port, ip_admin, port_admin)
      end

    estado = [subastas: x.subastas, usuarios: x.usuarios]
    GlobalContext.set_estado(estado)

    IO.puts("Conexion establecida con el administrador.")

    kill_task()
  end

  defp kill_task() do
    Process.exit(self(), :normal)
  end

end
