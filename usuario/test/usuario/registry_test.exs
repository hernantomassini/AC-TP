
defmodule Usuario.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    usuarioTest=%Modelo.Usuario{}
    usuarioTest=%{usuarioTest | id: "usuarioTest",ip: "127.0.0.1",puerto: "80"}
    Usuario.Registry.crear_usuario(usuarioTest)
    pidUsuarioTest=Usuario.Registry.get_pid_usuario(usuarioTest.id)
    %{pidUsuarioTest: pidUsuarioTest}
  end


  test "Crear usuario"  do
    usuario1=%Modelo.Usuario{}
    usuario2=%Modelo.Usuario{}
    usuario1=%{usuario1 | id: "idUsuario1",ip: "127.0.0.1",puerto: "80"}
    usuario2=%{usuario2 | id: "idUsuario2",ip: "127.0.33.1",puerto: "80"}
    Usuario.Registry.crear_usuario(usuario1)
    Usuario.Registry.crear_usuario(usuario2)

    assert  usuario1 = Usuario.Registry.get_estado("idUsuario1")
    assert  usuario2 = Usuario.Registry.get_estado("idUsuario2")
  end

  test "registrar_usuario", %{pidUsuarioTest: pidUsuarioTest} do
    Usuario.registrar_usuario(pidUsuarioTest)
  end

  test "consultar_usuario",%{pidUsuarioTest: pidUsuarioTest}  do
    Usuario.consultar_usuario(pidUsuarioTest)
  end

  test "crear_subasta",  %{pidUsuarioTest: pidUsuarioTest} do
#    Usuario.ofertar_subasta(pidUsuarioTest,subasta)
  end

end
