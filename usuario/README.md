# Cliente

## Para enviar un POST

u1 = %Modelo.Usuario{ id: "hola", ip: "189.1.2.4", puerto: 87, tags: nil }
Usuario.Registry.crear:usuario(u1)
pidu1 = Usuario.Registry.get_pid_usuario("hola")

Usuario.crear_subasta(pidu1)
Usuario.obtener_subasta(pidu1)
