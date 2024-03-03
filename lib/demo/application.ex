defmodule Demo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {ShutdownNotifier, message: "1"},
      DemoWeb.Telemetry,
      {ShutdownNotifier, message: "2"},
      Demo.Repo,
      {ShutdownNotifier, message: "3"},
      {DNSCluster, query: Application.get_env(:demo, :dns_cluster_query) || :ignore},
      {ShutdownNotifier, message: "4"},
      {Phoenix.PubSub, name: Demo.PubSub},
      {ShutdownNotifier, message: "5"},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Demo.Finch},
      {ShutdownNotifier, message: "6"},
      # Start a worker by calling: Demo.Worker.start_link(arg)
      # {Demo.Worker, arg},
      # Start to serve requests, typically the last entry
      DemoWeb.Endpoint,
      {ShutdownNotifier, message: "7"},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Demo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
