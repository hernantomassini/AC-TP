defmodule Notificacion.Application do
  @moduledoc false
  use Application


  def start(_type, _args) do
    # List all child processes to be supervised
    ip="127.0.0.1"
    port=8005
    GlobalContext.start_link([])
    GlobalContext.set_ip(ip)
    GlobalContext.set_port(port)
    endpoint="http://127.0.0.1:8085"
    GlobalContext.set_server_endpoint(endpoint)

    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: Notificacion.Router, options: [port: port]),
      Usuario.Registry
    ]
    Supervisor.start_link(children, strategy: :one_for_one)


  end

end
