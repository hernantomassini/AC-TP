# Servidor

## Envíar POST Usuario (/buyers)

u1 = %Modelo.Usuario{ id: "hernan", ip: "127.0.0.1", puerto: 8005, tags: ["PC", "gamer", "consola"] }
u2 = %Modelo.Usuario{ id: "jorge", ip: "127.0.0.1", puerto: 8005, tags: ["Elixir"] }
u3 = %Modelo.Usuario{ id: "subastador", ip: "127.0.0.1", puerto: 8005, tags: ["Subastar"] }

Usuario.Registry.crear_usuario(u1)
Usuario.Registry.crear_usuario(u2)
Usuario.Registry.crear_usuario(u3)

Usuario.registrar_usuario("jorge")
Usuario.registrar_usuario("hernan")
Usuario.registrar_usuario("subastador")

## Crear Subasta - POST (/bids)

Usuario.crear_subasta("subastador", ["PC", "Gamer", "Elixir"], 10, 120, "PC de escritorio", "El gabinete tiene lucesitas.")

## Ofertar en una subasta - PUT (/bids)

Usuario.ofertar_subasta("hernan", "5f187660-92fd-11e8-b9f5-88d7f67f5947", 500)
Usuario.ofertar_subasta("jorge", "e42a8260-9309-11e8-bcb4-88d7f67f5947", 600)
Usuario.ofertar_subasta("hernan", "5f187660-92fd-11e8-b9f5-88d7f67f5947", 700)

## Cancelar una subasta - DELETE (/bids)

Usuario.cancelar_subasta("jorge", "15676510-9304-11e8-89f8-88d7f67f5947")

## Ver subastas ofertadas - GET (/buyers/owns)

Usuario.subastas_ofertadas("jorge")

## Ver subastas de interés - GET (/buyers/interests)

Usuario.subastas_de_interes("jorge")

## Obtener una subasta - GET (/bids)

Usuario.obtener_subasta("8cd41bc0-935e-11e8-8638-88d7f67f5947")
