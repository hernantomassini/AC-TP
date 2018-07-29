# Servidor

## Envíar POST /buyers

u1 = %Modelo.Usuario{ id: "hernan", ip: "191.24.1.5", puerto: 2020, tags: ["PC", "gamer", "consola"] }
u2 = %Modelo.Usuario{ id: "jorge", ip: "1.1.1.1", puerto: 90, tags: ["Elixir"] }

Usuario.Registry.crear_usuario(u1)
Usuario.Registry.crear_usuario(u2)

Usuario.registrar_usuario("jorge")
Usuario.registrar_usuario("hernan")

## Envíar POST /bids

Usuario.crear_subasta("jorge", ["PC", "Gamer"], 10000, 5000, "PC de escritorio", "El gabinete tiene lucesitas.")
