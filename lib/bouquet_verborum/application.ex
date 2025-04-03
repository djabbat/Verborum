defmodule BouquetVerborum.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BouquetVerborumWeb.Telemetry,
      BouquetVerborum.Repo,
      BouquetVerborum.MariaRepo,
      {DNSCluster, query: Application.get_env(:bouquet_verborum, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BouquetVerborum.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BouquetVerborum.Finch},
      # Start a worker by calling: BouquetVerborum.Worker.start_link(arg)
      # {BouquetVerborum.Worker, arg},
      # Start to serve requests, typically the last entry
      BouquetVerborumWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BouquetVerborum.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BouquetVerborumWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
