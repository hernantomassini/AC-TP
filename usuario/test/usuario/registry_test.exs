
defmodule Usuario.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    pid_test_user=Persona.Test.get_pid()
    Usuario.registrar_usuario(pid_test_user)
    %{pid_usuarioTest: pid_test_user}
  end

  test "Crear usuario"  do
#    usuario1 = Modelo.Usuario.new("id_usuario1", ["tags","22"])#    usuario2 = Modelo.Usuario.new("id_usuario2", ["tags","23"])
#    Usuario.Registry.crear_usuario(usuario1)
#    Usuario.Registry.crear_usuario(usuario2)
#
#    assert usuario1 = Usuario.Registry.get_estado("id_usuario1")
#    assert usuario2 = Usuario.Registry.get_estado("id_usuario2")
    Persona.Miguel.start()
    assert usuarioMiguel = Usuario.Registry.get_estado("miguel")
end

  test "registrar_usuario", %{pid_usuarioTest: pid_usuarioTest} do
    Usuario.registrar_usuario(pid_usuarioTest)
  end

  test "subastas_ofertadas", %{pid_usuarioTest: pid_usuarioTest} do
    Usuario.subastas_ofertadas(pid_usuarioTest)
  end

#  test "crear_subasta", %{pid_usuarioTest: pid_usuarioTest} do
#    Usuario.crear_subasta(pid_usuarioTest, ["perritos", "videjuegos"], 45, 33, "Articulo1", "Compralo que esta buenisimo")
#  end
#
#  test "ofertar_subasta",  %{pid_usuarioTest: pid_usuarioTest} do
#    usuarioTest = Usuario.state(pid_usuarioTest)
#    Usuario.ofertar_subasta(pid_usuarioTest, "flura-id", 66)
#  end
##
#  test "cancelar_subasta", %{pid_usuarioTest: pid_usuarioTest} do
#    usuarioTest = Usuario.state(pid_usuarioTest)
#    subasta = Modelo.Subasta.new(usuarioTest.id, ["perritos", "videjuegos"] , 45, 33, "Articulo1", "Compralo que esta buenisimo")
#    Usuario.cancelar_subasta(pid_usuarioTest,subasta.id)
#  end

end
