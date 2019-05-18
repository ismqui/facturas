# Facturas

**TODO:**
- Refactorizar facturas_file.ex.
- Tratamiento de clientes.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `facturas` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:facturas, "~> 0.1.0"}
  ]
end
```

To generate a CLI script to execute:
```shell
$> mix escript.build
$> ./facturas
```
For now you need a facturas.csv with the format:

- 2018-12-19, 1, 2050.65, 21, 7, true, "Servicios informaticos"
- 2018-12-20, 2, 1050.65, 21, 7, true, "Servicios Python"
- 2018-12-21, 3, 2550.65, 21, 7, true, "Servicios Elixir"


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/facturas](https://hexdocs.pm/facturas).

```Menlo, Consolas, DejaVu Sans Mono, monospace
