# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :embercatcher_api,
  ecto_repos: [EmbercatcherApi.Repo]

# Configures the endpoint
config :embercatcher_api, EmbercatcherApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xIUgMBAC3ELMceMhE0oB4mmiZ5TsnYINjIcXY9MVi5PU4THUx1Hnf8F9C1/DvtMi",
  render_errors: [view: EmbercatcherApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: EmbercatcherApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
