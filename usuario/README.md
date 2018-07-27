# Cliente

## Para enviar un POST

s1 = %Subasta { id: 40, tags: ["PC", "Gamer", "Elixir"] }
s2 = %Subasta { id: 28, tags: ["elixir"] }
s3 = %Subasta { id: 28, tags: ["jota"] }
u1 = %Modelo.Usuario{ id: "hernan", ip: "191.24.1.5", puerto: 2020, tags: ["Elixir", "gamer", "consola"] }
u2 = %Modelo.Usuario{ id: "hernan", ip: "1.1.1.1", puerto: 90, tags: ["Jota"] }
Usuario.Registry.crear_usuario(u1)
Usuario.Registry.crear_usuario(u2)

Luego
> Usuario.obtener_subasta("idUsuario")

Alternativamente:
pidu1 = Usuario.Registry.get_pid_usuario("idUsuario")
> Usuario.obtener_subasta(pidu1)
