use Mix.Releases.Config,
  # This sets the default release built by `mix release`
  default_release: :default,
  # This sets the default environment used by `mix release`
  default_environment: :dev

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html

# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set(dev_mode: false)
  set(include_erts: false)

  set(
    cookie: System.get_env("DOCDOG_COOKIE") || "&ni4J65$&00OKB5$!AZ#RnybOr^oBU$hbEx8C4Rf3O0r%DSqkhiY7Vl#JH#Q%xqy"
  )
end

environment :prod do
  set(include_erts: false)
  set(include_src: false)

  set(
    cookie: System.get_env("DOCDOG_COOKIE") || "${DOCDOG_COOKIE}"
  )
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :docdog do
  set(version: current_version(:docdog))

  set commands: [
    "migrate": "rel/commands/migrate.sh"
  ]
end
