
defmodule Usuario.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = Usuario.Registry.start_link([])
    %{registry: registry}
  end

  test "Crear usuario", %{registry: registry} do
    usuario1=%Usuario.Struct{}
    usuario1=%{usuario1 | id: 'idUsuario1',ip: "127.0.0.1",puerto: "80"}
    Usuario.Registry.create(registry,usuario1)
    data=Usuario.Registry.lookup(registry,'idUsuario1')
    IO.puts(inspect(data))
    IO.puts(data.id)
#    data |> inspect |> Logger.debug

  end
end