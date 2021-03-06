use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :docdog, DocdogWeb.Endpoint,
  http: [port: 4001],
  secret_key_base: "+xONLYFORTESTSynmgIFCtSnwLoh7SP1PTPzJJq0Yh4vVDiY3O4+kbhlm+svVwS1",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :docdog, Docdog.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "postgresql://postgres:@db:5432/docdog_test", # TODO: Fix to env
  pool: Ecto.Adapters.SQL.Sandbox
