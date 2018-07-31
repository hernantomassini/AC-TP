defmodule FileFormat do
  defstruct [:server_maestro, :servers_activos]

  def new(server_maestro, servers_activos) do
    %FileFormat{server_maestro: Map.from_struct(server_maestro), servers_activos:  Enum.map(servers_activos, fn x -> Map.from_struct(x)end)}
  end

  def get_struct_endpoints(servers_activos) do
    Enum.map(servers_activos, fn x -> Util.struct_from_map(x, as: %Adrestia.Endpoint{}) end)
  end
end

defmodule Util do
  @moduledoc false


  def persistir_contexto_servidor() do
    {:ok, file} = File.open "servers_activos.txt", [:write]
    data=FileFormat.new(GlobalContext.get_endpoint_maestro(),GlobalContext.get_endpoints_activos())

    IO.binwrite file, inspect(Map.from_struct(data))
    File.close file
  end

  def iniciar_contexto_servidor() do
    response = File.read "servers_activos.txt"

    case response do
      {:ok, data } -> file_struct=Poison.decode(data, as: %FileFormat{})
                      server_maestro=Poison.decode(file_struct.server_maestro, as: %{})
                      servers_activos=Enum.map(file_struct.servers_activos, fn x -> Poison.decode(x, %{})end)

          GlobalContext.set_endpoint_maestro(  Util.struct_from_map(server_maestro, as: %Adrestia.Endpoint{}))
          GlobalContext.set_endpoints( FileFormat.get_struct_endpoints(servers_activos))

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
