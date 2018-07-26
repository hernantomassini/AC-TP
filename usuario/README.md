# Cliente

## Para enviar un POST

u1 = %Modelo.Usuario{ id: "idUsuario", ip: "189.1.2.4", puerto: 87, tags: nil }
Usuario.Registry.crear_usuario(u1)

pidu1 = Usuario.Registry.get_pid_usuario("idUsuario")

Luego
> Usuario.crear_subasta(pidu1)
> Usuario.obtener_subasta(pidu1)

Alternativamente:
> Usuario.crear_subasta(idUsuario)
> Usuario.obtener_subasta("idUsuario")
