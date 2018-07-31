defmodule Adrestia.Balancer do
  use GenServer

  def start_link(endpoints, strategy) do
    endpointsGlobal = GlobalContext.get_endpoints()
    GenServer.start_link(__MODULE__, {endpointsGlobal, [], strategy}, name: __MODULE__)
  end

  def init({endpoints, _, strategy}) do
    endpointsGlobal = GlobalContext.get_endpoints()
    servers = Enum.map(endpointsGlobal, fn(server) ->
      weight = Map.get(server, :weight, 1)
      server
        |> Map.put(:weight, weight)
        |> Map.put(:remaining_weight, weight)
    end)
    {:ok, {servers, [], strategy}}
  end

  def handle_call(:next_server, _from, {[], _, _} = state) do
    {:reply, :error, state}
  end

  def handle_call(:next_server, _from, {ups, downs, strategy}) do
    {server, new_ups} = Kernel.apply(strategy, :next_server, [ups])
    {:reply, server, {new_ups, downs, strategy}}
  end

  def handle_cast({:server_down, host}, {ups, downs, strategy}) do
    endpoints= GlobalContext.get_endpoints()
    #server = find_by_host(host, ups ++ downs)
    server = find_by_host(host, endpoints)

    rest = List.delete(ups, server)
    {:noreply, {rest, as_set([server | downs]), strategy}}
  end

  def handle_cast({:server_up, host}, {ups, downs, strategy}) do
    endpoints= GlobalContext.get_endpoints()
    #server = find_by_host(host, downs ++ ups)
    server = find_by_host(host, endpoints)
    rest = List.delete(downs, server)
    endpoints = as_set([server | ups])
    # Se guardan los endpoints activos cada cierto intervalo de tiempo
    GlobalContext.set_endpoints_activos(endpoints)
    GlobalContext.obtener_endpoint_maestro() #Vuelve a identiifcar si posee al maestro correcto
    {:noreply, { endpoints , rest, strategy}}
  end

  def handle_cast(:status, state) do
    IO.inspect state
    {:noreply, state}
  end

  defp find_by_host(host, endpoints) do
    endpointsGlobal = GlobalContext.get_endpoints()
    same_host = fn(%{:host => sv_host}) -> sv_host == host end
    Enum.find(endpointsGlobal, same_host)
  end

  defp as_set(list), do: list |> MapSet.new |> MapSet.to_list
end
