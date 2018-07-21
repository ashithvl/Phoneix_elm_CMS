# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :elm_phx_db_todo,
  ecto_repos: [ElmPhxDbTodo.Repo]

# Configures the endpoint
config :elm_phx_db_todo, ElmPhxDbTodoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TZBPg1eA/K9BNKxqNTBRAHvdX5u3OSHOSq+NRVxvLtBhT9v7tKqO0G1+B+RpaMid",
  render_errors: [view: ElmPhxDbTodoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ElmPhxDbTodo.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
