# Cliente

## Envíar POST Usuario (/buyers)

u1 = %Modelo.Usuario{ id: "hernan", ip: "127.0.0.1", puerto: 2020, tags: ["PC", "gamer", "consola"] }
u2 = %Modelo.Usuario{ id: "jorge", ip: "127.0.0.1", puerto: 90, tags: ["Elixir"] }

Usuario.Registry.crear_usuario(u1)
Usuario.Registry.crear_usuario(u2)

Usuario.registrar_usuario("jorge")
Usuario.registrar_usuario("hernan")

## Crear Subasta - POST (/bids)

Usuario.crear_subasta("jorge", ["PC", "Gamer"], 0, 120, "PC de escritorio", "El gabinete tiene lucesitas.")

## Ofertar en una subasta - PUT (/bids)

Usuario.ofertar_subasta("hernan", "5f187660-92fd-11e8-b9f5-88d7f67f5947", 500)
Usuario.ofertar_subasta("jorge", "5f187660-92fd-11e8-b9f5-88d7f67f5947", 600)
Usuario.ofertar_subasta("hernan", "5f187660-92fd-11e8-b9f5-88d7f67f5947", 700)

## Cancelar una subasta - DELETE (/bids)

Usuario.cancelar_subasta("jorge", "15676510-9304-11e8-89f8-88d7f67f5947")
