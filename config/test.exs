use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :docdog, DocdogWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :docdog, Docdog.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_USERNAME") || "postgres",
  password: System.get_env("DATABASE_PASSWORD") || "postgres",
  database: System.get_env("DATABASE_NAME") || "docdog_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
