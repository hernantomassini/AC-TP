defmodule Usuario.Registry do
  @moduledoc false
    use GenServer

    ## Client API

    @doc """
    Starts the registry.
    """
    def start_link(opts) do
      GenServer.start_link(__MODULE__, :ok, opts)
    end

    @doc """
    Looks up the bucket pid for `usuario` stored in `server`.

    Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
    """
    def getEstado(server, idUsuario) do
      GenServer.call(server, {:getEstado, idUsuario})
    end

  def getPidUsuario(server, idUsuario) do
    GenServer.call(server, {:getPidUsuario, idUsuario})
  end

    @doc """
    Ensures there is a bucket associated with the given `usuario` in `server`.
    usuario es de tipo %Usuario.State{}
    """
    def create(server, usuario) do
      GenServer.cast(server, {:create, usuario})
    end

    def getUsuarios(server) do
      GenServer.call(server, {:getUsuarios})
    end




    ## Server Callbacks

    def init(:ok) do
      {:ok, %{}}
    end

    def handle_call({:getEstado, idUsuario}, _from, usuarios) do
      {:ok,usuarioPid}= Map.fetch(usuarios, idUsuario)
      {:reply, Usuario.State.get(usuarioPid), usuarios}
    end

    def handle_call({:getUsuarios}, _from, usuarios) do
      {:reply, Map.keys(usuarios), usuarios}
    end

    def handle_call({:getPidUsuario, idUsuario}, _from, usuarios) do
      {:ok,usuarioPid}= Map.fetch(usuarios, idUsuario)
      {:reply, usuarioPid, usuarios}
    end

    def handle_cast({:create, usuario}, usuarios) do
      if Map.has_key?(usuarios, usuario.id) do
        {:noreply, usuarios}
      else
        {:ok, instance} = Usuario.State.start_link([])
        Usuario.State.save(instance,usuario)
        {:noreply, Map.put(usuarios, usuario.id, instance)}
      end
    end
  end  
