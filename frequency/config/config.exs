# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :frequency, FrequencyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yQf5botzhmZkp26rQfBOvbj5ig33KO2Tb+KxrlMp8GiU/NutkrtBxLkD+VJsRjUs",
  render_errors: [view: FrequencyWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Frequency.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "ky947sA8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
