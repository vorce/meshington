# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :meshington,
  ecto_repos: [Meshington.Repo]

# Configures the endpoint
config :meshington, MeshingtonWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SMt6w+WSlnFoPfdBDjpNvneqhjaKgV/pzKZZLbbST28JJWc8lkzHSvzkBqsTDNy6",
  render_errors: [view: MeshingtonWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Meshington.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :module]

config :meshington, Meshington.Net.Server,
  port: String.to_integer(System.get_env("PORT") || "3511")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
