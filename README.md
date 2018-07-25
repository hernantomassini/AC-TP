# SubastaAutomatica

## Installation

First, if not installed, install Hex.
> mix local.hex

Install dependencies
> mix deps.get

## Tips - GenServer

Lo principal es entender que en la funcion cast se defino las funcionas que luego se va a usar en la interfaz. Esas funciones son implementan con call.

- [call/3]: es una respuesta sincrónica, es un mensaje bloqueante
- [cast/2]: es una respuesta asincrónica, puede o no tener una respuesta

## Configuración para el Supervisor

- :max_restarts- cuántos reinicios están permitidos dentro del marco de tiempo
- :max_seconds-el tiempo real

Ejemplo:

```elixir
def init(_) do
  supervise(
    [ worker(SubastaAutomatica, [0]) ],
    max_restarts: 5,
    max_seconds: 6,
    strategy: :one_for_one
  )
end
```

## Comandos de curl:

- curl -H 'Content-Type: application/json' "http://localhost:8085/buyers" -d '{"message": "hello world" }'
- curl -H 'Content-Type: application/json' "http://localhost:8085/bids" -d '{"message": "Test Subasta" }'
- curl "http://localhost:8085/hello"

## Comando importantes, se ejecutan AC-TP

- **iex -S mix** : entrar en elixir y ya esta configurado el supervisor, cuando se le manda una división por 0, este se cae pero vuelve a levantar.
- **mix test**: ejecuta los tests
