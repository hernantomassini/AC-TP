defmodule Notificacion.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    ip = System.get_env("ip") || "127.0.0.1"
    port = System.get_env("port") || "8005"
    ip_admin = System.get_env("ip_admin") || "127.0.0.1"
    port_admin =  System.get_env("port_admin") || "1234"

    GlobalContext.start_link([])
    GlobalContext.set_ip(ip)
    GlobalContext.set_port(port)
    endpoint="http://#{ip_admin}:#{port_admin}"
    GlobalContext.set_server_endpoint(endpoint)

    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: Notificacion.Router, options: [port: String.to_integer(port)]),
      Usuario.Registry
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
