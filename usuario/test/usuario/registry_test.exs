
defmodule Usuario.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = Usuario.Registry.start_link([])
    %{registry: registry}
  end

  test "Crear usuario", %{registry: registry} do
    usuario1=%Usuario.Struct{}
    usuario2=%Usuario.Struct{}
    usuario1=%{usuario1 | id: 'idUsuario1',ip: "127.0.0.1",puerto: "80"}
    usuario2=%{usuario2 | id: 'idUsuario2',ip: "127.0.33.1",puerto: "80"}
    Usuario.Registry.create(registry,usuario1)
    Usuario.Registry.create(registry,usuario2)

    dataUsuario1=Usuario.Registry.getEstado(registry,'idUsuario1')
    dataUsuario2=Usuario.Registry.getEstado(registry,'idUsuario2')
    assert usuario1 = Usuario.Registry.getEstado(registry,'idUsuario1')
    assert usuario2 = Usuario.Registry.getEstado(registry,'idUsuario2')

    IO.puts(inspect(dataUsuario1))
    IO.puts(inspect(dataUsuario2))

   pidUsuario1=Usuario.Registry.getPidUsuario(registry,'idUsuario1')
   IO.inspect(pidUsuario1,label: "PID")
    Usuario.State.crearSubasta(pidUsuario1)

    #    data |> inspect |> Logger.debug

  end
end