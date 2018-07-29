defmodule Server.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: Server.Router, options: [port: 8086]),
      GlobalContext
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
