
defmodule Usuario.RegistryTest do
  use ExUnit.Case, async: true

  test "Crear usuario" do
    usuario1=%Modelo.Usuario{}
    usuario2=%Modelo.Usuario{}
    usuario1=%{usuario1 | id: 'idUsuario1',ip: "127.0.0.1",puerto: "80"}
    usuario2=%{usuario2 | id: 'idUsuario2',ip: "127.0.33.1",puerto: "80"}
    Usuario.Registry.crear_usuario(usuario1)
    Usuario.Registry.crear_usuario(usuario2)

    dataUsuario1=Usuario.Registry.get_estado('idUsuario1')
    dataUsuario2=Usuario.Registry.get_estado('idUsuario2')
    assert usuario1 = Usuario.Registry.get_estado('idUsuario1')
    assert usuario2 = Usuario.Registry.get_estado('idUsuario2')

    IO.puts(inspect(dataUsuario1))
    IO.puts(inspect(dataUsuario2))

   pidUsuario1=Usuario.Registry.get_pid_usuario('idUsuario1')
   IO.inspect(pidUsuario1,label: "PID")
   Usuario.registrar_usuario(pidUsuario1)

    #    data |> inspect |> Logger.debug

  end
end
