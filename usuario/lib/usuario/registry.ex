defmodule Usuario.Registry do
  @moduledoc false
    use GenServer

    ## Client API

    @doc """
    Starts the registry.
    """
    def start(_type, _args) do
      GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
    end

    @doc """
    Looks up the bucket pid for `usuario` stored in `server`.

    Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
    """
    def get_estado(id_usuario) do
      GenServer.call(__MODULE__, {:get_estado, id_usuario})
    end

    def get_pid_usuario(id_usuario) do
      GenServer.call(__MODULE__, {:get_pid_usuario, id_usuario})
    end

    @doc """
    Ensures there is a bucket associated with the given `usuario` in `server`.
    usuario es de tipo %Usuario.State{}
    """
    def create(usuario) do
      GenServer.cast(__MODULE__, {:create, usuario})
    end

    def get_usuarios() do
      GenServer.call(__MODULE__, {:get_usuarios})
    end

    def crear_usuario() do
      GenServer.call(__MODULE__, {:get_usuarios})
    end


    ## Server Callbacks

    def init(:ok) do
      {:ok, %{}}
    end

    def handle_call({:get_estado, id_usuario}, _from, usuarios) do
      {:ok,usuario_pid}= Map.fetch(usuarios, id_usuario)
      {:reply, Usuario.State.get(usuario_pid), usuarios}
    end

    def handle_call({:get_usuarios}, _from, usuarios) do
      {:reply, Map.keys(usuarios), usuarios}
    end

    def handle_call({:get_pid_usuario, id_usuario}, _from, usuarios) do
      {:ok,usuario_pid}= Map.fetch(usuarios, id_usuario)
      {:reply, usuario_pid, usuarios}
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
