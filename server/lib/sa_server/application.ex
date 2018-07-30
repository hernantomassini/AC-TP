defmodule Server.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    name = System.get_env("name") || raise "Missing $name environment variable."
    ip = System.get_env("ip") || raise "Missing $ip environment variable."
    port = System.get_env("port") || raise "Missing $port environment variable."
    ip_admin = System.get_env("ip_admin") || raise "Missing $ip_admin environment variable."
    port_admin = System.get_env("port_admin") || raise "Missing $PORT environment variable."

    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: Server.Router, options: [port: String.to_integer(port)]),
      GlobalContext,
      { Task, fn -> AdministradorTask.inicializar(name, ip, port, ip_admin, port_admin) end }
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
