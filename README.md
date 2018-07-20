# SubastaAutomatica

**Los test se ejecutan con: mix test**

## Tips

[call/3]: es una respuesta sincrónica, es un mensaje bloqueante
[cast/2]: es una respuesta asincrónica, puede o no tener una respuesta:


If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `subastaautomatica` to your list of dependencies in `mix.exs`:

En el handle_cast(operation, state) se define las funciones.
En el  handle_call(:result, _, state) se utilizan las funciones en forma asincrona. 
```elixir
def deps do
  [
    {:subastaautomatica, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/subastaautomatica](https://hexdocs.pm/subastaautomatica).

