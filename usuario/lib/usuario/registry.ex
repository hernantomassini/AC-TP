defmodule Usuario.Registry do
  @moduledoc false
    use GenServer

    ## Client API

    def start_link(_args) do
      GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
    end

    def get_estado(id_usuario) do
      GenServer.call(__MODULE__, {:get_estado, id_usuario})
    end

    def get_pid_usuario(id_usuario) do
      GenServer.call(__MODULE__, {:get_pid_usuario, id_usuario})
    end

    def crear_usuario(usuario) do
      GenServer.cast(__MODULE__, {:create, usuario})
    end

    def get_usuarios() do
      GenServer.call(__MODULE__, {:get_usuarios})
    end

    def existe_usuario(id_usuario) do
#    Process.alive?(
      user_pid=Usuario.Registry.get_pid_usuario(id_usuario)
      if user_pid == nil do
        false
      else
        Process.alive?(user_pid)
      end
    end

   ## Server Callbacks

    def init(:ok) do
      {:ok, %{}}
    end



    def handle_call({:get_estado, id_usuario}, _from, usuarios) do
      {:ok,usuario_pid}= Map.fetch(usuarios, id_usuario)
      {:reply,Usuario.state(usuario_pid), usuarios}
    end

    def handle_call({:get_usuarios}, _from, usuarios) do
      {:reply, Map.keys(usuarios), usuarios}
    end

    def handle_call({:get_pid_usuario, id_usuario}, _from, usuarios) do
      if Map.has_key?(usuarios, id_usuario) do
        {:ok, usuario_pid} = Map.fetch(usuarios, id_usuario)
        {:reply, usuario_pid, usuarios}
      else
        {:reply, nil, usuarios}
      end


    end

    def handle_cast({:create, usuario}, usuarios) do
      if Map.has_key?(usuarios, usuario.id) do
        {:noreply, usuarios}
      else
        {:ok, instance} = Usuario.start_link([])
       Usuario.save(instance,usuario)
        {:noreply, Map.put(usuarios, usuario.id, instance)}
      end
    end
  end
