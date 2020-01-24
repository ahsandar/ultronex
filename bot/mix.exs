defmodule UltronEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :ultronex,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  def escript do
    [main_module: UltronexApp]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :logger,
        :cowboy,
        :plug,
        :plug_cowboy,
        :poison,
        :eex,
        :logger_file_backend,
        :honeybadger
      ],
      mod: {UltronexApp, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:slack, "~> 0.19.0"},
      {:tesla, "~> 1.2.1"},
      {:poison, "~> 3.1"},
      {:new_relic_agent, "~> 1.0"},
      {:cowboy, "~> 2.6.3"},
      {:plug, "~> 1.8.3"},
      {:plug_cowboy, "~> 2.1.0"},
      {:dialyxir, "~> 0.4", only: [:dev]},
      {:basic_auth, "~> 2.2.2"},
      {:logger_file_backend, "~> 0.0.10"},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:sentry, "~> 7.0"},
      {:jason, "~> 1.1"},
      {:honeybadger, "~> 0.13.0"}
    ]
  end
end
