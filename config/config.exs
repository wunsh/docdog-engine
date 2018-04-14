# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :docdog, ecto_repos: [Docdog.Repo]

# Configures the endpoint
config :docdog, DocdogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE") || "${SECRET_KEY_BASE}",
  render_errors: [view: DocdogWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Docdog.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

config :phoenix_slime, :use_slim_extension, true

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, []}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID") || "${GITHUB_CLIENT_ID}",
  client_secret: System.get_env("GITHUB_CLIENT_SECRET") || "${GITHUB_CLIENT_SECRET}"

config :mime, :types, %{
  "text/markdown" => ["md"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
