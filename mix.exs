defmodule Docdog.Mixfile do
  use Mix.Project

  def project do
    [
      app: :docdog,
      version: "0.1.1",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Docdog.Application, []},
      extra_applications: [
        :ex_machina,
        :logger,
        :runtime_tools,
        :ueberauth_github
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_slime, git: "https://github.com/slime-lang/phoenix_slime"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:ueberauth_github, "~> 0.4"},
      {:cowboy, "~> 1.0"},
      {:distillery, "~> 1.0.0"},
      {:bodyguard, "~> 2.2"},
      {:ex_machina, "~> 2.1"},

      # Development and testing:
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.8", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
