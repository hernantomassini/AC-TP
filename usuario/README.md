# Cliente

## Para enviar un POST

u1 = %Modelo.Usuario{ id: "idUsuario", ip: "189.1.2.4", puerto: 87, tags: nil }
u2 = %Modelo.Usuario{ id: "hernan", ip: "1.1.1.1", puerto: 90, tags: nil }
Usuario.Registry.crear_usuario(u1)
Usuario.Registry.crear_usuario(u2)

Luego
> Usuario.obtener_subasta("idUsuario")

Alternativamente:
pidu1 = Usuario.Registry.get_pid_usuario("idUsuario")
> Usuario.obtener_subasta(pidu1)
