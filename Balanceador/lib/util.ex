defmodule FileFormat do
  defstruct [:server_maestro, :servers_activos]

  def new(server_maestro, servers_activos) do
    %FileFormat{server_maestro: server_maestro, servers_activos: servers_activos}
  end


end

defmodule Util do
  @moduledoc false


  def persistir_contexto_servidor(endpoints) do
    {:ok, file} = File.open "servers_activos.txt", [:write]
    data_a_guardar = Enum.map(endpoints, fn x -> %Adrestia.Endpoint{host: x.host, name: x.name, weight: x.weight} end)
    data=FileFormat.new(GlobalContext.get_endpoint_maestro(),data_a_guardar)

    IO.binwrite file, Poison.encode!(data)
    File.close file
  end

  def iniciar_contexto_servidor() do
    response = File.read "servers_activos.txt"

    case response do
      {:ok, data } ->

                      file_struct=Poison.decode!(data, as: %FileFormat{})
                      IO.inspect(file_struct, label: "DATA_REUCPERADA")
                      server_maestro=Util.struct_from_map(file_struct.server_maestro, as: %Adrestia.Endpoint{})
                      IO.inspect(server_maestro, label: "server_maestro")
                      servers_activos=Enum.map(file_struct.servers_activos, fn x -> Util.struct_from_map(x, as: %Adrestia.Endpoint{})end)
                      IO.inspect(servers_activos, label: "servers_activos")
                      GlobalContext.set_endpoint_maestro( server_maestro)
                       GlobalContext.set_endpoints( servers_activos)

      {:error, _} ->
        GlobalContext.set_endpoint_maestro(nil)
        GlobalContext.set_endpoints([])
    end

  end

  def struct_from_map(a_map, as: a_struct) do
    # Find the keys within the map
    keys = Map.keys(a_struct)
           |> Enum.filter(fn x -> x != :__struct__ end)
    # Process map, checking for both string / atom keys
    processed_map =
      for key <- keys, into: %{} do
        value = Map.get(a_map, key) || Map.get(a_map, to_string(key))
        {key, value}
      end
    a_struct = Map.merge(a_struct, processed_map)
    a_struct
  end



end
