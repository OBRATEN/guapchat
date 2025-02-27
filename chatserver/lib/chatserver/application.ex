defmodule Chatserver.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ChatserverWeb.Telemetry,
      Chatserver.Repo,
      {DNSCluster, query: Application.get_env(:chatserver, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Chatserver.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Chatserver.Finch},
      # Start a worker by calling: Chatserver.Worker.start_link(arg)
      # {Chatserver.Worker, arg},
      # Start to serve requests, typically the last entry
      ChatserverWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Chatserver.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChatserverWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
