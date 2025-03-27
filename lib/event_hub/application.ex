defmodule EventHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EventHubWeb.Telemetry,
      # EventHub.Repo,
      {DNSCluster, query: Application.get_env(:event_hub, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EventHub.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: EventHub.Finch},
      # Start a worker by calling: EventHub.Worker.start_link(arg)
      # {EventHub.Worker, arg},
      # Start to serve requests, typically the last entry
      # EventHubWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EventHub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EventHubWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
