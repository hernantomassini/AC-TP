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

    IO.puts "Se envia un request #{request.verb} al: #{url}"

    #if request.verb == :post and request.path =="inicializar" do
    #  IO.puts "=)"
      #endpointsNew = GlobalContext.get_endpoints()
      #endpointsNew2 = endpointsNew ++ [%{name: "server1", host: "localhost:8085", weight: 3}]
      #GlobalContext.set_endpoints(endpointsNew2)
    #end

    broadcast(request, request_extras)

    if request.verb == :get and request.path =="replicar" do
      endpointsActivos = GlobalContext.get_endpoints_activos()

      if !is_nil(endpointsActivos) do
        endpointsFiltered = Enum.filter(endpointsActivos, fn x -> x.host != request.endpoint.host end)


        if length(endpointsFiltered) == 0 do
          send_resp(request.conn, 418, ["No existen servidores donde se pueda hacer la replica"])
          #put_response(request, responseServer)
        else
          endpointFirst = hd(endpointsFiltered)
          IO.inspect(endpointFirst, label: "First")
          urlServer = endpointFirst.host  <> "/"  <> request.path
          responseServer = HTTPotion.request(request.verb, urlServer, request_extras)
          put_response(request, responseServer)
          #IO.inspect(responseServer, label: "responseServer TEST")
        end
      end
    else
      response = HTTPotion.request(request.verb, url, request_extras)
      put_response(request, response)
    end
  end


  def broadcast(request, request_extras) do
    endpoints = GlobalContext.get_endpoints_activos()
    #IO.inspect(endpoints, label: "Endpoints Activos")

    if request.verb != :get and !is_nil(endpoints) do
      endpointsFiltered = Enum.filter(endpoints, fn x -> x.host != request.endpoint.host end)
      #IO.inspect(endpointsFiltered, label: "Endpoints para replicacion")
      Enum.map(endpointsFiltered, fn endpoint ->
        urlPost = endpoint.host  <> "/"  <> request.path
        HTTPotion.request(request.verb, urlPost, request_extras)
      end)
    end
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
