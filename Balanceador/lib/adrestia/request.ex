defmodule Adrestia.Request do
  alias Adrestia.Cache

  import Plug.Conn

  defstruct [:verb, :conn, :path,
             :query_string, :response,
             :endpoint, :headers, :status_code,
             :cacheable?, :body]

  def from_conn(conn) do
    {:ok, body, conn} = read_body(conn)
    %Adrestia.Request{verb: verb(conn)}
      |> Map.put(:conn, conn)
      |> Map.put(:path, path(conn))
      |> Map.put(:query_string, query_string(conn))
      |> Map.put(:cacheable?, cacheable?(conn))
      |> Map.put(:body, body)
      |> Map.put(:headers, Keyword.new(conn.req_headers, fn({key, value}) -> {String.to_atom(key), value} end))
  end

  def put_endpoint(request, server) do
    %{request | endpoint: server}
  end

  def put_response(request, %HTTPotion.ErrorResponse{} = response) do
    %{request | response: response}
  end

  def put_response(request, response) do
    request
      |> Map.put(:response, response)
      |> Map.put(:headers, response.headers.hdrs)
      |> Map.put(:status_code, response.status_code)
      |> Map.put(:body, response.body)
  end

  def send(request) do
    url = request.endpoint.host <> "/" <> request.path <> request.query_string
    request_extras = [ibrowse: [max_sessions: 100]]
      |> put_in_extras(:headers, request.headers)
      |> put_in_extras(:body, request.body)

    IO.puts "Recibo request #{request.verb} de: #{url}"

    urlServer=url
    endpoint_maestro=GlobalContext.obtener_endpoint_maestro()
    #Si no es un get y no es nil entonces ejecuta
    IO.puts("SERVER_MAESTRO: #{inspect(endpoint_maestro)}")

    #VERIFICAR EL INICLAIZAR
    if request.verb == :post and request.path =="inicializar"  do
      servidor_a_agregar = Poison.decode!(request.body, as: %Adrestia.Endpoint{})
      IO.inspect(servidor_a_agregar, label: "BODYYY 2")
      endpointsNew = GlobalContext.get_endpoints()
      if !Enum.member?(endpointsNew, servidor_a_agregar) do
        endpointsNew2 = endpointsNew ++ [servidor_a_agregar]
        GlobalContext.set_endpoints(endpointsNew2)
      end
      send_resp(request.conn, :service_unavailable, "Servers Configurado #{request.body} ")
    else
        if request.verb == :post and request.path =="sincronizar" do
          IO.inspect(GlobalContext.get_endpoints_esclavos(), label: "ESCLAVOS")
          broadcast_esclavos(request, request_extras)
          send_resp(request.conn, :ok, "Servers #{inspect(GlobalContext.get_endpoints_esclavos())} sincronizados ")
          else
            #or request.path =="replicar"
            #Todo tipo de peiticon se lo manda al maestro
            unless request.verb == :get or is_nil(endpoint_maestro) or request.path == "sincronizar" or request.path =="inicializar" do
              urlServer = endpoint_maestro.host <> "/" <> request.path
              IO.puts "Se envia  request #{request.verb} hacia: #{urlServer}"
            end

            if request.path !="sincronizar"  do
              response = HTTPotion.request(request.verb, urlServer, request_extras)
            end

            put_response(request, response)
        end


#    send_resp(request.conn, :service_unavailable, "There are no servers available")
    end


#    broadcast(request, request_extras)
#    if request.verb == :post and request.path == "replicar" do
#      endpointsActivos = GlobalContext.get_endpoints_activos()
#      servidor_destino = Poison.decode!(request.body, as: %Adrestia.Endpoint{})
#
#      # IO.inspect(servidor_destino, label: "servidor_destino")
#      # IO.inspect(request.endpoint.host, label: "REPLICA_host")
#
#      if !is_nil(endpointsActivos) do
#        endpointsFiltered = Enum.filter(endpointsActivos, fn x -> x.host != servidor_destino.host end)
#
#        if length(endpointsFiltered) == 0 do
#          send_resp(request.conn, 418, ["No existen servidores donde se pueda hacer la replica"])
#        else
#          endpoint_a_pedir_estado = hd(endpointsFiltered)
#          urlServer = endpoint_a_pedir_estado.host <> "/" <> request.path
#
#          IO.puts("Pido el estado al server #{endpoint_a_pedir_estado.host}")
#          responseServer = HTTPotion.request(request.verb, urlServer, request_extras)
#
#          IO.puts("Envio el estado al server #{request.endpoint.host}")
#          send_resp(request.conn, 200, responseServer.body)
#        end
#      end
#    else
#      response = HTTPotion.request(request.verb, url, request_extras)
#      put_response(request, response)
#    end
  end




  defp broadcast_esclavos(request, request_extras) do
    endpoints_esclavos = GlobalContext.get_endpoints_esclavos()
    #UNLESS: si alguno es true, no ejecuta
      IO.puts("Ejecuto broadcast")
      #IO.inspect(endpointsFiltered, label: "Endpoints para replicacion")
      Enum.map(endpoints_esclavos, fn endpoint ->
        urlPost = endpoint.host  <> "/"  <> request.path
        HTTPotion.request(request.verb, urlPost, request_extras)
      end)
  end

  defp put_in_extras(extras, _, nil), do: extras
  defp put_in_extras(extras, key, option), do: [{key, option} | extras]

  defp verb(conn), do: conn.method |> String.downcase |> String.to_atom

  defp path(conn), do: Enum.join(conn.path_info, "/")

  defp query_string(conn) do
    case conn.query_string do
                     "" -> ""
                     qs -> "?" <> qs
    end
  end

  defp cacheable?(conn) do
    non_cacheable = fn(header) -> header in [{"cache-control", "no-cache"}, {"expires", "0"}] end
    not Enum.any?(conn.req_headers, non_cacheable) and Cache.enabled?()
  end
end
