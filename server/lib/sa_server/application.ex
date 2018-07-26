defmodule SaServer.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: SaServer.Router, options: [port: 8085]),
      SaServer
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
