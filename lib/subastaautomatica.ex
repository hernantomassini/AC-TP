defmodule SubastaAutomatica do
  use GenServer
 
  def start(initial_value) do
    GenServer.start(CalcServer, initial_value, name: __MODULE__)
  end

  def init(initial_value) when is_number(initial_value) do
    {:ok, initial_value}
  end
 
  def init(_) do
    {:stop, "El valor tiene que ser un tipo integer!"}
  end

  def handle_cast(operation, state) do
    case operation do
      :sqrt -> {:noreply, :math.sqrt(state)}
      {:multiply, multiplier} -> {:noreply, state * multiplier}
      {:suma, operador} -> {:noreply, state + operador}
      _ -> {:stop, "No existe implementacion", state}
    end
  end

  def handle_call(:result, _, state) do
    {:reply, state, state}
  end

  def result do
    GenServer.call( __MODULE__, :result)
  end

  def terminate(_reason, _state) do
    IO.puts "Se apaga el server, BOOM!"
  end

  def sqrt do
    ##GenServer.cast(pid, :sqrt)
    GenServer.cast( __MODULE__, :sqrt)
  end

  def multiply(multiplier) do
    ##GenServer.cast(pid, {:multiply, multiplier})
      GenServer.cast( __MODULE__, {:multiply, multiplier})
  end

  def suma(operador) do
    ##GenServer.cast(pid, {:suma, add})
    GenServer.cast( __MODULE__, {:suma, operador})
  end
end



##Cuando trabajamos con el PID identifiación del proceso
##GenServer.start(CalcServer, 5.1) |> IO.inspect 
##{:ok, pid} = GenServer.start(CalcServer, 100) 
##CalcServer.sqrt(pid)
##CalcServer.multiply(pid, 5)
##CalcServer.result(pid)

##{:ok, pid} = GenServer.start(CalcServer, 25) |> IO.inspect
##CalcServer.sqrt(pid)
##CalcServer.multiply(pid, 2)
##CalcServer.suma(pid, 2) |> IO.puts 
##CalcServer.sqrt(pid)
##CalcServer.result(pid)|> IO.puts


##Sin el PID, se le pone un nombre al proceso
##CalcServer.start(100)
##CalcServer.sqrt
##CalcServer.multiply(2)
##CalcServer.suma(8)
##CalcServer.result |> IO.puts