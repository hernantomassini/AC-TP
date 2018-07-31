defmodule AdminContext do
  @moduledoc false
  use Agent

  @derive [Poison.Encoder]
  defstruct [:subastas, :usuarios, :active]

  def start_link(_opts) do
    Agent.start_link(fn -> [ip: "127.0.0.1", puerto: "1234"] end, name: __MODULE__)
  end

  # type es un átomo :ip o :puerto
  defp get(type) when is_atom(type) do
    Agent.get(__MODULE__, fn data -> data[type] end)
  end

  defp put(type, value) when is_atom(type) do
    Agent.update(__MODULE__, fn data -> put_in(data[type], value) end)
  end

  #---------------------------------------

  def get_host() do
    ip = get(:ip)
    port = get(:puerto)
    ip <> ":" <> port
  end

  def set_ip(ip) do
    put(:ip, ip)
  end

  def set_port(port) do
    put(:puerto, port)
  end

end
