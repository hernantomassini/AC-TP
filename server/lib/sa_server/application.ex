defmodule Server.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    name="server1"
    ip="127.0.0.1"
    port="8085"
    ip_admin="127.0.0.1"
    port_admin="1234"

    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: Server.Router, options: [port: String.to_integer(port)]),
      GlobalContext,
      { Task, fn -> AdministradorTask.inicializar(name, ip, port, ip_admin, port_admin) end }
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
