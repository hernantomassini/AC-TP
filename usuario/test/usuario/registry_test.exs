
defmodule Usuario.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    usuarioTest = Modelo.Usuario.new("usuarioTest", ["tags", "22"])
    Usuario.Registry.crear_usuario(usuarioTest)
    pidUsuarioTest = Usuario.Registry.get_pid_usuario(usuarioTest.id)
    %{pidUsuarioTest: pidUsuarioTest}
  end

  test "Crear usuario"  do
    usuario1 = Modelo.Usuario.new("idUsuario1", ["tags","22"])
    usuario2 = Modelo.Usuario.new("idUsuario2", ["tags","23"])
    Usuario.Registry.crear_usuario(usuario1)
    Usuario.Registry.crear_usuario(usuario2)

    assert usuario1 = Usuario.Registry.get_estado("idUsuario1")
    assert usuario2 = Usuario.Registry.get_estado("idUsuario2")
  end

  test "registrar_usuario", %{pidUsuarioTest: pidUsuarioTest} do
    Usuario.registrar_usuario(pidUsuarioTest)
  end

  test "consultar_usuario", %{pidUsuarioTest: pidUsuarioTest} do
    Usuario.consultar_usuario(pidUsuarioTest)
  end

  test "crear_subasta", %{pidUsuarioTest: pidUsuarioTest} do
    Usuario.crear_subasta(pidUsuarioTest, ["perritos", "videjuegos"], 45, 33, "Articulo1", "Compralo que esta buenisimo")
  end

  test "ofertar_subasta",  %{pidUsuarioTest: pidUsuarioTest} do
    usuarioTest = Usuario.state(pidUsuarioTest)
    subasta = Modelo.Subasta.new(usuarioTest.id, ["perritos", "videjuegos"], 45, 33, "Articulo1", "Compralo que esta buenisimo")
    Usuario.ofertar_subasta(pidUsuarioTest, subasta.id, 66)
  end

  test "cancelar_subasta", %{pidUsuarioTest: pidUsuarioTest} do
    usuarioTest = Usuario.state(pidUsuarioTest)
    subasta = Modelo.Subasta.new(usuarioTest.id, ["perritos", "videjuegos"] , 45, 33, "Articulo1", "Compralo que esta buenisimo")
    Usuario.cancelar_subasta(pidUsuarioTest,subasta.id)
  end

end
