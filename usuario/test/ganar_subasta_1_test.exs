
defmodule GanarSubasta1 do
  use ExUnit.Case, async: true

  @moduledoc false

  setup do
    pid_test_user=Persona.Test.get_pid()
    %{pid_usuarioTest: pid_test_user}
  end


  test "Crear subasta" , %{pid_usuarioTest: pid_test_user} do
    IO.puts("asdasda #{inspect(pid_test_user)}")
  end

end


