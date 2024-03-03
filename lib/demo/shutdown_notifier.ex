defmodule ShutdownNotifier do
  use GenServer
  require Logger

  defmodule State do
    defstruct [:message]
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  def child_spec(opts \\ []) do
    message = Access.get(opts, :message)

    default = %{
      id: {__MODULE__, message},
      start: {__MODULE__, :start_link, [opts]},
    }

    Supervisor.child_spec(default, [])
  end

  @impl GenServer
  def init(opts) do
    message = Access.get(opts, :message)

    state = %State{
      message: message,
    }

    # We need to trap exits so that we receive the `terminate/2` callback during
    # a graceful shutdown
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  # NOTE: We cannot guarantee that this will run on every shutdown, it will only
  # get run on graceful shutdowns such as via a SIGTERM which is what Render
  # uses as part of their zero-downtime deploys.
  @impl GenServer
  def terminate(_reason, state) do
    Logger.info("Shutting down ShutdownNotifier #{state.message}")
    :ok
  end
end
