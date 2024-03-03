Repro https://github.com/elixir-ecto/postgrex/issues/667

Reproduce with:
```
mix deps.get
iex -S mix phx.server
\# wait for server to boot
iex> System.stop()
```

The output will contain logs like:
```
[info] Postgrex.Protocol (#PID<0.413.0>) missed message: {:EXIT, #PID<0.459.0>, :shutdown}
[info] Postgrex.Protocol (#PID<0.415.0>) missed message: {:EXIT, #PID<0.459.0>, :shutdown}
[info] Postgrex.Protocol (#PID<0.409.0>) missed message: {:EXIT, #PID<0.459.0>, :shutdown}
[info] Postgrex.Protocol (#PID<0.414.0>) missed message: {:EXIT, #PID<0.459.0>, :shutdown}
[info] Postgrex.Protocol (#PID<0.410.0>) missed message: {:EXIT, #PID<0.459.0>, :shutdown}
```
