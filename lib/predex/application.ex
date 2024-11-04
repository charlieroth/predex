defmodule Predex.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PredexWeb.Telemetry,
      Predex.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:predex, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:predex, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Predex.PubSub},
      {Finch, name: Predex.Finch},
      PredexWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Predex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    PredexWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    System.get_env("RELEASE_NAME") != nil
  end
end
