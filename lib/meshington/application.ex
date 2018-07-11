defmodule Meshington.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Start the Ecto repository
      supervisor(Meshington.Repo, []),

      worker(Meshington.Database, []),

      # Start the endpoint when the application starts
      supervisor(MeshingtonWeb.Endpoint, []),

      # Start accepting peer connections
      supervisor(Meshington.Net.Supervisor, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Meshington.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MeshingtonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
