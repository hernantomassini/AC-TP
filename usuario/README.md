# Cliente

## Para enviar un POST

u1 = %Usuario.Struct{ id: "hola", ip: "189.1.2.4", puerto: 87, tags: nil }
Registry.create(u1)
pidu1 = Registry.get_pid_usuario("hola")
Usuario.State.crear_subasta(pidu1)
