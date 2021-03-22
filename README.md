# Backdoor

A supervised reverse tcp backdoor and localhost listener.
You can change the connection host and port as well as the listening port in the config.exs file.

## building

if you want to build a standalone executable you can run the following command on a machine with the target architechture:

```bash
MIX_ENV=prod mix release
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `backdoor` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:backdoor, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/backdoor](https://hexdocs.pm/backdoor).
